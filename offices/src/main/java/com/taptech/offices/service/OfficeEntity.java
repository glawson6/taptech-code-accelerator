package com.taptech.offices.service;

import com.fasterxml.jackson.annotation.JsonInclude;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import lombok.*;

@Entity
@JsonInclude(JsonInclude.Include.NON_NULL)
@Data
@EqualsAndHashCode(onlyExplicitlyIncluded = true)
@NoArgsConstructor
@AllArgsConstructor
@ToString
@Getter
@Setter
@Builder
public class OfficeEntity{
        @Id
        @GeneratedValue(strategy = GenerationType.UUID)
        String id;
        String name;
        String address;
        String city;
        String state;
        String zip;
        Double latitude;
        Double longitude;
        String open;
        String close;
}
