package poly.Test;


import poly.Manager.IUserManager;
import poly.Manager.UserManager;
import poly.entity.User;

import java.util.List;

public class Main {
    public static void main(String[] args) {
        IUserManager manager = new UserManager();

        // manager.create();
        // manager.update();
        // manager.deleteById("U01");
        // manager.findById("U01");
//        manager.findAll();

        // bai 3
//        String domain= "@fpt.edu.vn";
//        Boolean isAdmin= false;
//        manager.findByEmailDomainAndRole(domain,isAdmin);
        //bai4
        UserManager dao = new UserManager();
        int pageNumber = 2;   // Trang số 3
        int pageSize = 5;     // Mỗi trang 5 user

        List<User> list = dao.findByPage(pageNumber,pageSize);
    }
}