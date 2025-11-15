package poly.Manager;

import poly.entity.User;

import java.util.List;

public interface IUserManager {
    void findAll();

    void findById(String Id);

    void create();

    void update();

    void deleteById(String Id);

    void findByEmailDomainAndRole(String domain, Boolean isAdmin);

    List<User> findByPage(int pageNumber , int pageSize);
}
