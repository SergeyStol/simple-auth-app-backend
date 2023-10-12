package dev.sstol.auth;

import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.ToString;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@SpringBootApplication
@RestController
public class SimpleAuthAppBackendApplication {

   public static void main(String[] args) {
      SpringApplication.run(SimpleAuthAppBackendApplication.class, args);
   }

   @GetMapping("/users")
   List<User> getAllUsers() {
      return List.of(
        new User("Name1", "Surname1"),
        new User("Name2", "Surname2"));
   }

   @NoArgsConstructor
   @Getter
   @EqualsAndHashCode
   @ToString
   class User {
      String name;
      String surname;

      public User(String name, String surname) {
         this.name = name;
         this.surname = surname;
      }
   }
}
