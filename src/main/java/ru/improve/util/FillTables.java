package ru.improve.util;

import ru.improve.models.Person;

import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.List;

public class FillTables {

    public List<Object> fillPersonTable(List<String[]> people) {
        return fillTable(people, Person.class);
    }

    private List<Object> fillTable(List<String[]> records, Class tableClass) {
        try {
            Field[] fields = tableClass.getDeclaredFields();
            int fieldNumber = fields.length;

            List<Object> objectList = new ArrayList<>();
            for (String[] record : records) {
                Object instance = tableClass.getDeclaredConstructor().newInstance();
                String[] values = record[0].split(" ");
                for (int i = 0; i < fieldNumber - 1; i++) {
                    String value = values[i];
                    Field field = fields[i + 1];

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
        }
        throw new IllegalArgumentException("Unsupported type: " + type);
    }
}
