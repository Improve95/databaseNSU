package ru.improve.util.parser;

import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.List;

public class RecordsReader {

    public List<Object> getObjectList(List<String[]> records, Class tableClass, int skipColumnNumber) {
        try {
            Field[] fields = tableClass.getDeclaredFields();
            int fieldNumber = fields.length;

            List<Object> objectList = new ArrayList<>();
            for (String[] record : records) {
                Object instance = tableClass.getDeclaredConstructor().newInstance();
                for (int i = 0; i < fieldNumber - skipColumnNumber; i++) {
                    String value = record[i];
                    Field field = fields[i + skipColumnNumber];

                    String fieldName = field.getName();
                    String fieldNameInSetter = "set" + Character.toUpperCase(fieldName.charAt(0)) + fieldName.substring(1);

                    Method method = tableClass.getMethod(fieldNameInSetter, field.getType());

                    Object typedValue = convertValue(value, field.getType());
                    method.invoke(instance, typedValue);
                }
                objectList.add(instance);
            }
            return objectList;
        } catch (NoSuchMethodException e) {
            throw new RuntimeException(e);
        } catch (InvocationTargetException e) {
            throw new RuntimeException(e);
        } catch (IllegalAccessException e) {
            throw new RuntimeException(e);
        } catch (InstantiationException e) {
            throw new RuntimeException(e);
        }
    }

    private Object convertValue(String value, Class<?> type) {
        if (String.class.equals(type)) {
            return value;
        } else if (type.equals(int.class) || type.equals(Integer.class)) {
            return Integer.valueOf(value);
        } else if (type.equals(long.class) || type.equals(Long.class)) {
            return Integer.valueOf(value);
        }
        throw new IllegalArgumentException("Unsupported type: " + type);
    }
}
