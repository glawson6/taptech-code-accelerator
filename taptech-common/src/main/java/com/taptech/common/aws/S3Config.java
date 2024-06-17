package com.taptech.common.aws;

import org.springframework.boot.autoconfigure.condition.ConditionalOnMissingBean;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import software.amazon.awssdk.auth.credentials.*;
import software.amazon.awssdk.http.apache.ApacheHttpClient;
import software.amazon.awssdk.services.s3.S3Client;

@ConditionalOnProperty(prefix = "s3", name = "enabled", havingValue = "true", matchIfMissing = false)
@Configuration
@EnableConfigurationProperties({S3Properties.class})
public class S3Config {

    @Bean
    @ConditionalOnMissingBean(AwsCredentials.class)
    AwsCredentials awsCredentials(S3Properties s3Properties){
        return AwsBasicCredentials.create(s3Properties.getAccessKey(), s3Properties.getSecretKey());
    }

    @Bean
    @ConditionalOnMissingBean(AwsCredentialsProvider.class)
    AwsCredentialsProvider awsCredentialsProvider(AwsCredentials awsCredentials){
        return StaticCredentialsProvider.create(awsCredentials);
    }

    @Bean
    @ConditionalOnMissingBean(S3Client.class)
    S3Client s3Client(S3Properties s3Properties, AwsCredentialsProvider awsCredentialsProvider){
        //AwsCredentials credentials = AwsBasicCredentials.create(s3Properties.getAccessKey(), s3Properties.getSecretKey());
        //AwsCredentialsProvider awsCredentialsProvider = StaticCredentialsProvider.create(awsCredentials);
        return S3Client.builder()
                .region(s3Properties.getRegion())
                .httpClientBuilder(ApacheHttpClient.builder())
                .credentialsProvider(awsCredentialsProvider)
                .build();
    }

    @Bean
    S3Helper s3Helper(S3Client s3Client){
        return S3Helper.builder()
                .s3Client(s3Client)
                .build();
    }
}
