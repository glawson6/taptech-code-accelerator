package com.taptech.common.security.user;

import io.swagger.annotations.ApiModelProperty;
import lombok.*;

import java.util.Objects;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Getter
@Setter
@ToString
public class UserContextRequest {
    @ApiModelProperty(required = false, value = "")
    String userId;
    @ApiModelProperty(required = false, value = "")
    String contextId;
    @ApiModelProperty(required = false, value = "")
    Boolean allRoles;
    @ApiModelProperty(required = false, value = "")
    String roles;
    @ApiModelProperty(required = false, value = "")
    String cacheControl;
    @ApiModelProperty(required = false, value = "")
    String token;

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        UserContextRequest that = (UserContextRequest) o;
        return Objects.equals(userId, that.userId) && Objects.equals(contextId, that.contextId);
    }

    @Override
    public int hashCode() {
        return Objects.hash(userId, contextId);
    }
}
