package org.springframework.cc;


import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.springframework.security.core.SpringSecurityCoreVersion;

/**
 * For computing different Spring Security versions
 */
public final class SpringSecurityVersions {

    static final Pattern SCHEMA_VERSION_PATTERN = Pattern.compile("\\d+\\.\\d+(\\.\\d+)?");

    public static String getCurrentXsdVersionFromSpringSchemas() {
        Properties properties = new Properties();
        try (InputStream is = SpringSecurityCoreVersion.class.getClassLoader()
                .getResourceAsStream("META-INF/spring.schemas")) {
            properties.load(is);
        }
        catch (IOException ex) {
            throw new RuntimeException("Could not read 'META-INF/spring.schemas'", ex);
        }

        String inPackageLocation = properties
                .getProperty("https://www.springframework.org/schema/security/spring-security.xsd");
        Matcher matcher = SCHEMA_VERSION_PATTERN.matcher(inPackageLocation);
        if (matcher.find()) {
            return matcher.group(0);
        }
        throw new IllegalStateException("Failed to find version");
    }

    private SpringSecurityVersions() {

    }

}