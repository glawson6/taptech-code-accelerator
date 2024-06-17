package com.taptech.common.aws;

import org.springframework.context.annotation.Import;

import java.lang.annotation.*;

@Retention(RetentionPolicy.RUNTIME)
@Target({ElementType.TYPE})
@Documented
@Import({S3Config.class})
public @interface EnableS3Helper {
}
