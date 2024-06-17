package org.springframework.cc;

import java.util.Arrays;
import java.util.Collection;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.Map;
import java.util.Set;

import jakarta.servlet.MultipartConfigElement;
import jakarta.servlet.Servlet;
import jakarta.servlet.ServletRegistration;
import jakarta.servlet.ServletSecurityElement;

import org.springframework.lang.NonNull;
import org.springframework.web.servlet.DispatcherServlet;

public class MockServletContext extends org.springframework.mock.web.MockServletContext {

    private final Map<String, ServletRegistration> registrations = new LinkedHashMap<>();

    public static MockServletContext mvc() {
        MockServletContext servletContext = new MockServletContext();
        servletContext.addServlet("dispatcherServlet", DispatcherServlet.class).addMapping("/");
        return servletContext;
    }

    @NonNull
    @Override
    public ServletRegistration.Dynamic addServlet(@NonNull String servletName, Class<? extends Servlet> clazz) {
        ServletRegistration.Dynamic dynamic = new MockServletRegistration(servletName, clazz);
        this.registrations.put(servletName, dynamic);
        return dynamic;
    }

    @NonNull
    @Override
    public Map<String, ? extends ServletRegistration> getServletRegistrations() {
        return this.registrations;
    }

    @Override
    public ServletRegistration getServletRegistration(String servletName) {
        return this.registrations.get(servletName);
    }

    private static class MockServletRegistration implements ServletRegistration.Dynamic {

        private final String name;

        private final Class<?> clazz;

        private final Set<String> mappings = new LinkedHashSet<>();

        MockServletRegistration(String name, Class<?> clazz) {
            this.name = name;
            this.clazz = clazz;
        }

        @Override
        public void setLoadOnStartup(int loadOnStartup) {

        }

        @Override
        public Set<String> setServletSecurity(ServletSecurityElement constraint) {
            return null;
        }

        @Override
        public void setMultipartConfig(MultipartConfigElement multipartConfig) {

        }

        @Override
        public void setRunAsRole(String roleName) {

        }

        @Override
        public void setAsyncSupported(boolean isAsyncSupported) {

        }

        @Override
        public Set<String> addMapping(String... urlPatterns) {
            this.mappings.addAll(Arrays.asList(urlPatterns));
            return this.mappings;
        }

        @Override
        public Collection<String> getMappings() {
            return this.mappings;
        }

        @Override
        public String getRunAsRole() {
            return null;
        }

        @Override
        public String getName() {
            return this.name;
        }

        @Override
        public String getClassName() {
            return this.clazz.getName();
        }

        @Override
        public boolean setInitParameter(String name, String value) {
            return false;
        }

        @Override
        public String getInitParameter(String name) {
            return null;
        }

        @Override
        public Set<String> setInitParameters(Map<String, String> initParameters) {
            return null;
        }

        @Override
        public Map<String, String> getInitParameters() {
            return null;
        }

    }

}
