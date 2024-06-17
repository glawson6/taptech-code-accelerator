package com.taptech.offices

import com.taptech.offices.service.OfficeEntity
import com.taptech.offices.service.OfficeRepository
import org.slf4j.Logger
import org.slf4j.LoggerFactory

class IntegrationTestDataLoader {
    private static final Logger logger = LoggerFactory.getLogger(IntegrationTestDataLoader.class);

    OfficeRepository officeRepository;

    IntegrationTestDataLoader(OfficeRepository officeRepository) {
        this.officeRepository = officeRepository
    }

    OfficeRepository getOfficeRepository() {
        return officeRepository
    }

    public void deleteTestData() {
        officeRepository.deleteAll();
    }

    public void load10TestData() {
        for (int i = 0; i < 10; i++) {
            OfficeEntity office = new OfficeEntity();
            office.setName("Test Office " + i);
            office.setAddress("Test Address " + i);
            office.setCity("Test City " + i);
            office.setLatitude(0.0);
            office.setLongitude(0.0);
            logger.info("Saving office: " + office.toString());
            office = officeRepository.save(office);
            logger.info("Saved office: " + office.toString());
        }
        logger.info("Saved {}",officeRepository.count())
    }
}
