package poly.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "Users")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class User {

    @Id
    @Column(name = "id")
     String id;

    @Column(name = "password")
     String password;

    @Column(name = "fullname")
     String fullname;

    @Column(name = "email")
     String email;

    @Column(name = "admin")
     Boolean admin = false;

    
}
