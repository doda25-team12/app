package frontend;

import doda25.team12.VersionUtil;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;

@SpringBootApplication
public class Main {

    public static void main(String[] args) {
        SpringApplication.run(Main.class, args);
    }

    // 2. Add this new block to print the version on startup
    @Bean
    public CommandLineRunner checkLibraryVersion() {
        return args -> {
            VersionUtil util = new VersionUtil();
            System.out.println("========================================");
            System.out.println(" LIBRARY VERSION: " + util.getVersion());
            System.out.println("========================================");
        };
    }

}