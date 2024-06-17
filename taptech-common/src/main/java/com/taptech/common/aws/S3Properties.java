package com.taptech.common.aws;

import lombok.*;
import org.springframework.boot.context.properties.ConfigurationProperties;
import software.amazon.awssdk.regions.Region;

@ConfigurationProperties(prefix = "s3")
@EqualsAndHashCode(onlyExplicitlyIncluded = true)
@NoArgsConstructor
@AllArgsConstructor
@Data
@Getter
@Setter
@ToString
public class S3Properties {

    String accessKey;
    String secretKey;
    Boolean enabled;
    //@Builder.Default
    Region region = Region.US_EAST_1;
}
