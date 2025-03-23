package ru.improve.abs.util;

import lombok.experimental.UtilityClass;

@UtilityClass
public class Util {

    public <T extends Enum<T>> T getEnumFromString(String enumString,  Class<T> enumClass) {
        Enum.valueOf(enumClass, enumString);
        return null;
    }
}
