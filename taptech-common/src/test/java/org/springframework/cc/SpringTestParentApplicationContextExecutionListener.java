package org.springframework.cc;


import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.List;

import org.springframework.context.ApplicationContext;
import org.springframework.test.context.TestContext;
import org.springframework.test.context.TestExecutionListener;

public class SpringTestParentApplicationContextExecutionListener implements TestExecutionListener {

    @Override
    public void beforeTestMethod(TestContext testContext) throws Exception {
        ApplicationContext parent = testContext.getApplicationContext();
        Object testInstance = testContext.getTestInstance();
        getContexts(testInstance).forEach((springTestContext) -> springTestContext
                .postProcessor((applicationContext) -> applicationContext.setParent(parent)));
    }

    private static List<SpringTestContext> getContexts(Object test) throws IllegalAccessException {
        Field[] declaredFields = test.getClass().getDeclaredFields();
        List<SpringTestContext> result = new ArrayList<>();
        for (Field field : declaredFields) {
            if (SpringTestContext.class.isAssignableFrom(field.getType())) {
                result.add((SpringTestContext) field.get(test));
            }
        }
        return result;
    }

}