package csd230.bookstore;


import com.github.javafaker.Commerce;
import com.github.javafaker.Faker;
import csd230.bookstore.entities.*;
import csd230.bookstore.repositories.*;
import jakarta.transaction.Transactional;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;


@SpringBootApplication
public class Application implements CommandLineRunner {
    private final ProductEntityRepository productRepository;
    private final CartEntityRepository cartRepository;
    private final UserEntityRepository userRepository;
    private final LaptopRepository laptopRepository;
    private final PhoneRepository phoneRepository;
    private final MagazineEntityRepository magazineRepository;
    private final PasswordEncoder passwordEncoder;


    public Application(ProductEntityRepository productRepository,
                       CartEntityRepository cartRepository,
                       UserEntityRepository userRepository,
                       LaptopRepository laptopRepository,
                       PhoneRepository phoneRepository,
                       MagazineEntityRepository magazineRepository,
                       PasswordEncoder passwordEncoder
    ) {
        this.productRepository = productRepository;
        this.cartRepository = cartRepository;
        this.userRepository = userRepository;
        this.laptopRepository = laptopRepository;
        this.phoneRepository = phoneRepository;
        this.magazineRepository = magazineRepository;
        this.passwordEncoder = passwordEncoder;
    }


    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }


    @Override
    @Transactional
    public void run(String... args) throws Exception {
        Faker faker = new Faker();
        Commerce cm = faker.commerce();
        com.github.javafaker.Number number = faker.number();
        com.github.javafaker.Book fakeBook = faker.book();
        String name = cm.productName();
        String description = cm.material();

        for (int i = 0; i < 10; i++) {
            // We call the faker methods inside the loop so each book gets unique data
            String title = faker.book().title();
            String author = faker.book().author();
            String priceString = faker.commerce().price();

            // Create the book entity with the random data
            BookEntity book = new BookEntity(
                    title,
                    Double.parseDouble(priceString),
                    10,      // Defaulting to 10 copies each
                    author
            );

            // Save to database
            productRepository.save(book);

            System.out.println("Saved Book " + (i + 1) + ": " + title + " by " + author);
        }

        for (int i = 0; i < 5; i++) {
            MagazineEntity mag = new MagazineEntity();
            mag.setTitle(faker.book().title() + " Monthly");
            mag.setPrice(Double.parseDouble(faker.commerce().price()));
            mag.setCopies(20);
            mag.setOrderQty(100);
            mag.setCurrentIssue(java.time.LocalDateTime.now());
            productRepository.save(mag);
            System.out.println("Saved Magazine " + (i + 1) + ": " + mag.getTitle());
        }

        // 2. Generate Fake Laptops
        String[] laptopBrands = {"Dell", "Apple", "Lenovo", "HP", "ASUS"};
        for (int i = 0; i < 5; i++) {
            LaptopEntity laptop = new LaptopEntity();
            laptop.setBrand(laptopBrands[i % 5]);
            laptop.setModel(faker.commerce().productName());
            laptop.setPrice(Double.parseDouble(faker.commerce().price(500, 2500)));
            laptop.setQuantity(10);
            laptop.setStorage(512);
            laptop.setCpu("Intel i" + (i % 2 == 0 ? "7" : "9"));
            laptop.setRam(16);
            productRepository.save(laptop);
            System.out.println("Saved Laptop " + (i + 1) + ": " + laptop.getBrand() + " " + laptop.getModel());
        }

        // 3. Generate Fake Phones
        String[] phoneBrands = {"Samsung", "iPhone", "Google", "OnePlus"};
        for (int i = 0; i < 5; i++) {
            PhoneEntity phone = new PhoneEntity();
            phone.setBrand(phoneBrands[i % 4]);
            phone.setModel(faker.commerce().productName());
            phone.setPrice(Double.parseDouble(faker.commerce().price(300, 1200)));
            phone.setQuantity(15);
            phone.setStorage(128);
            phone.setOs(i % 2 == 0 ? "Android" : "iOS");
            productRepository.save(phone);
            System.out.println("Saved Phone " + (i + 1) + ": " + phone.getBrand() + " " + phone.getModel());
        }

        // ------------------------------------
        // CREATE USERS (Lecture 2.6)
        // ------------------------------------

        // Admin User (Can Add/Edit/Delete)
        UserEntity admin = new UserEntity("admin", passwordEncoder.encode("admin"), "ADMIN");
        userRepository.save(admin);


        // Regular User (Can only View/Buy)
        UserEntity user = new UserEntity("user", passwordEncoder.encode("user"), "USER");
        userRepository.save(user);


        System.out.println("Default users created: admin/admin and user/user");

        // Check if a cart exists, if not, create one
        if (cartRepository.count() == 0) {
            CartEntity defaultCart = new CartEntity();
            cartRepository.save(defaultCart);
            System.out.println("Default Cart created with ID: " + defaultCart.getId());
        }
    }
    @Bean
    public WebMvcConfigurer corsConfigurer() {
        return new WebMvcConfigurer() {
            @Override
            public void addCorsMappings(CorsRegistry registry) {
                // Allow access to all /api endpoints from any origin
                registry.addMapping("/api/**").allowedOrigins("*");
            }
        };
    }



}

