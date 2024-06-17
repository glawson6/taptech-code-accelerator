package org.springframework.cc;

import org.springframework.beans.BeansException;
import org.springframework.beans.factory.support.DefaultListableBeanFactory;
import org.springframework.beans.factory.xml.XmlBeanDefinitionReader;
import org.springframework.context.ApplicationContext;
import org.springframework.core.io.Resource;
import org.springframework.security.util.InMemoryResource;
import org.springframework.web.context.support.AbstractRefreshableWebApplicationContext;

/**
 * @author Joe Grandja
 */
public class InMemoryXmlWebApplicationContext extends AbstractRefreshableWebApplicationContext {

    private Resource inMemoryXml;

    public InMemoryXmlWebApplicationContext(String xml) {
        this(xml, InMemoryXmlApplicationContext.SPRING_SECURITY_VERSION, null);
    }

    public InMemoryXmlWebApplicationContext(String xml, ApplicationContext parent) {
        this(xml, InMemoryXmlApplicationContext.SPRING_SECURITY_VERSION, parent);
    }

    public InMemoryXmlWebApplicationContext(String xml, String secVersion, ApplicationContext parent) {
        String fullXml = InMemoryXmlApplicationContext.BEANS_OPENING + secVersion + ".xsd'>\n" + xml
                + InMemoryXmlApplicationContext.BEANS_CLOSE;
        this.inMemoryXml = new InMemoryResource(fullXml);
        setAllowBeanDefinitionOverriding(true);
        setParent(parent);
    }

    @Override
    protected void loadBeanDefinitions(DefaultListableBeanFactory beanFactory) throws BeansException {
        XmlBeanDefinitionReader reader = new XmlBeanDefinitionReader(beanFactory);
        reader.loadBeanDefinitions(new Resource[] { this.inMemoryXml });
    }

}