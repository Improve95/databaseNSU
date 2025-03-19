package ru.improve.abs.configuration.security;

import lombok.RequiredArgsConstructor;
import org.springframework.cache.CacheManager;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.acls.domain.AclAuthorizationStrategyImpl;
import org.springframework.security.acls.domain.ConsoleAuditLogger;
import org.springframework.security.acls.domain.DefaultPermissionGrantingStrategy;
import org.springframework.security.acls.domain.SpringCacheBasedAclCache;
import org.springframework.security.acls.jdbc.BasicLookupStrategy;
import org.springframework.security.acls.jdbc.JdbcMutableAclService;
import org.springframework.security.acls.model.MutableAclService;
import org.springframework.security.core.authority.SimpleGrantedAuthority;

import javax.sql.DataSource;

import static ru.improve.abs.core.security.SecurityUtil.ADMIN_ROLE;

@RequiredArgsConstructor
@Configuration
public class AclConfig {

    private final CacheConfig cacheConfig;

    @Bean
    public ConsoleAuditLogger auditLogger() {
        return new ConsoleAuditLogger();
    }

    @Bean
    public DefaultPermissionGrantingStrategy permissionGrantingStrategy() {
        return new DefaultPermissionGrantingStrategy(auditLogger());
    }

    @Bean
    public AclAuthorizationStrategyImpl aclAuthorizationStrategy() {
        return new AclAuthorizationStrategyImpl(new SimpleGrantedAuthority(ADMIN_ROLE));
    }

    @Bean
    public SpringCacheBasedAclCache cacheBasedAclCache(CacheManager cacheManager) {
        return new SpringCacheBasedAclCache(
                cacheManager.getCache(cacheConfig.getCacheNames().get(0)),
                permissionGrantingStrategy(),
                aclAuthorizationStrategy()
        );
    }

    @Bean
    public BasicLookupStrategy lookupStrategy(DataSource dataSource, SpringCacheBasedAclCache cacheBasedAclCache) {
        BasicLookupStrategy lookupStrategy = new BasicLookupStrategy(
                dataSource,
                cacheBasedAclCache,
                aclAuthorizationStrategy(),
                permissionGrantingStrategy()
        );
        lookupStrategy.setAclClassIdSupported(true);
        return lookupStrategy;
    }

    @Bean
    public MutableAclService mutableAclService(DataSource dataSource, CacheManager cacheManager) {
        SpringCacheBasedAclCache cacheBasedAclCache = cacheBasedAclCache(cacheManager);
        BasicLookupStrategy lookupStrategy = lookupStrategy(dataSource, cacheBasedAclCache);

        JdbcMutableAclService mutableAclService = new JdbcMutableAclService(
                dataSource,
                lookupStrategy,
                cacheBasedAclCache
        );
        mutableAclService.setSidIdentityQuery("select currval('acl_sid_id_seq')");
        mutableAclService.setClassIdentityQuery("select currval('acl_class_id_seq')");
        mutableAclService.setAclClassIdSupported(true);

        return mutableAclService;
    }
}
