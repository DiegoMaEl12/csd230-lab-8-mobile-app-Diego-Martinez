package csd230.bookstore.controllers;

import csd230.bookstore.entities.PhoneEntity;
import csd230.bookstore.repositories.PhoneRepository;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/rest/phones")
@CrossOrigin(origins = "*")
public class PhoneController {
    private final PhoneRepository phoneRepository;
    public PhoneController(PhoneRepository phoneRepository) {
        this.phoneRepository = phoneRepository;
    }
    @GetMapping
    public List<PhoneEntity> getAllPhones() {
        return phoneRepository.findAll();
    }
    @GetMapping("/{id}")
    public ResponseEntity<PhoneEntity> getPhoneById(@PathVariable Long id) {
        return phoneRepository.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }
    @PostMapping
    public PhoneEntity createPhone(@RequestBody PhoneEntity phone) {
        return phoneRepository.save(phone);
    }
    @PutMapping("/{id}")
    public ResponseEntity<PhoneEntity> updatePhone(@PathVariable Long id, @RequestBody PhoneEntity details) {
        return phoneRepository.findById(id)
                .map(phone -> {
                    phone.setBrand(details.getBrand());
                    phone.setModel(details.getModel());
                    phone.setPrice(details.getPrice());
                    phone.setQuantity(details.getQuantity());
                    phone.setStorage(details.getStorage());
                    phone.setOs(details.getOs());
                    return ResponseEntity.ok(phoneRepository.save(phone));
                })
                .orElse(ResponseEntity.notFound().build());
    }
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deletePhone(@PathVariable Long id) {
        if (phoneRepository.existsById(id)) {
            phoneRepository.deleteById(id);
            return ResponseEntity.ok().build();
        }
        return ResponseEntity.notFound().build();
    }
}
