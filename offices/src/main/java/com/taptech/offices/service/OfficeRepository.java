package com.taptech.offices.service;

import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;


@Repository
public interface OfficeRepository extends CrudRepository<OfficeEntity, String> {

    Optional<OfficeEntity> findByName(String name);
    List<OfficeEntity> findByNameIn(List<String> names);
}
