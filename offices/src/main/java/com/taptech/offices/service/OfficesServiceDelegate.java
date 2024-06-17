package com.taptech.offices.service;

import com.taptech.offices.model.Office;
import com.taptech.offices.model.OfficePage;
import com.taptech.offices.server.OfficesApiDelegate;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.NoArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.web.server.ServerWebExchange;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.math.BigDecimal;
import java.util.Optional;
import java.util.function.BiFunction;
import java.util.function.Function;
import java.util.function.Supplier;

@Builder
@NoArgsConstructor
@AllArgsConstructor
public class OfficesServiceDelegate implements OfficesApiDelegate {
    private static final Logger logger = LoggerFactory.getLogger(OfficesServiceDelegate.class);
    public static final Supplier<RuntimeException> OFFICE_NOT_FOUND_EXCEPTION_SUPPLIER = () -> new RuntimeException("Office not found");


    OfficeRepository officeRepository;

    public static Function<OfficeEntity, Office> convertOfficeEntityToOffice = officeEntity -> {
        Office office = new Office();
        office.setId(officeEntity.getId());
        office.setName(officeEntity.getName());
        office.setAddress(officeEntity.getAddress());
        office.setLatitude(officeEntity.getLatitude());
        office.setLongitude(officeEntity.getLongitude());
        office.setCity(officeEntity.getCity());
        office.setState(officeEntity.getState());
        office.setZip(officeEntity.getZip());
        office.setOpen(officeEntity.getOpen());
        office.setClose(officeEntity.getClose());
        return office;
    };

   public  static Function<Office, OfficeEntity> convertOfficeToOfficeEntity = office -> {
        logger.info("convertOfficeToOfficeEntity: {}", office);
        OfficeEntity officeEntity = OfficeEntity.builder()
                .name(office.getName())
                .zip(office.getZip())
                .longitude(office.getLongitude())
                .open(office.getOpen())
                .state(office.getState())
                .close(office.getClose())
                .city(office.getCity())
                .address(office.getAddress())
                .latitude(office.getLatitude())
                .id(office.getId())
                .build();
        return officeEntity;
    };

    static BiFunction<String, Office, OfficeEntity> updateOfficeEntity = (id, office) -> {
        logger.info("updateOfficeEntity: {}", office);
        OfficeEntity officeEntity = OfficeEntity.builder()
                .id(id)
                .build();
        officeEntity.setName(Optional.ofNullable(office.getName()).orElse(officeEntity.getName()));
        officeEntity.setZip(Optional.ofNullable(office.getZip()).orElse(officeEntity.getZip()));
        officeEntity.setLongitude(Optional.ofNullable(office.getLongitude()).orElse(officeEntity.getLongitude()));
        officeEntity.setOpen(Optional.ofNullable(office.getOpen()).orElse(officeEntity.getOpen()));
        officeEntity.setState(Optional.ofNullable(office.getState()).orElse(officeEntity.getState()));
        officeEntity.setClose(Optional.ofNullable(office.getClose()).orElse(officeEntity.getClose()));
        officeEntity.setCity(Optional.ofNullable(office.getCity()).orElse(officeEntity.getCity()));
        officeEntity.setAddress(Optional.ofNullable(office.getAddress()).orElse(officeEntity.getAddress()));
        officeEntity.setLatitude(Optional.ofNullable(office.getLatitude()).orElse(officeEntity.getLatitude()));
        return officeEntity;
    };

    @Override
    public Mono<ResponseEntity<Office>> createOffice(Mono<Office> pOffice, ServerWebExchange exchange) {
        return pOffice.flatMap(office -> {
            logger.info("createOffice: {}", office);
            return Mono.fromCallable(() -> officeRepository.save(convertOfficeToOfficeEntity.apply(office)))
                    .map(convertOfficeEntityToOffice)
                    .map(ResponseEntity::ok);
        });
    }

    @Override
    public Mono<ResponseEntity<Void>> deleteOfficeById(String id, ServerWebExchange exchange) {
        return Mono.just(id)
                .flatMap(officeId -> Mono.fromCallable(() -> {
                    officeRepository.deleteById(officeId);
                    return ResponseEntity.noContent().build();
                }));
    }

    @Override
    public Mono<ResponseEntity<OfficePage>> findOffices(BigDecimal latitude, BigDecimal longitude, ServerWebExchange exchange) {
        return OfficesApiDelegate.super.findOffices(latitude, longitude, exchange);
    }

    @Override
    public Mono<ResponseEntity<Office>> getOfficeById(String id, ServerWebExchange exchange) {
        return Mono.just(id)
                .flatMap(officeId -> Mono.fromCallable(() -> officeRepository.findById(officeId)))
                .map(office -> office.map(convertOfficeEntityToOffice)
                        .map(ResponseEntity::ok)
                        .orElse(ResponseEntity.notFound().build()));
    }

    @Override
    public Mono<ResponseEntity<OfficePage>> getOffices(ServerWebExchange exchange) {
        return Mono.defer(() -> Mono.fromCallable(() -> officeRepository.findAll()))
                .flatMapMany(Flux::fromIterable)
                .map(convertOfficeEntityToOffice)
                .collectList()
                .map(offices -> {
                    OfficePage officePage = new OfficePage();
                    officePage.setContent(offices);
                    return officePage;
                })
                .map(ResponseEntity::ok);
    }

    @Override
    public Mono<ResponseEntity<Office>> updateOfficeById(String id, Mono<Office> office, ServerWebExchange exchange) {
        return Mono.just(id)
                .flatMap(officeId -> Mono.fromCallable(() -> officeRepository.findById(officeId).orElseThrow(OFFICE_NOT_FOUND_EXCEPTION_SUPPLIER)))
                .flatMap(officeEntity -> office.map(update -> updateOfficeEntity.apply(id, update))
                        .map(officeRepository::save)
                        .map(convertOfficeEntityToOffice))
                .map(ResponseEntity::ok);
    }
}
