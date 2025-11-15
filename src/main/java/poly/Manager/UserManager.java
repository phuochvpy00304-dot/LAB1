package poly.Manager;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import jakarta.persistence.TypedQuery;
import poly.entity.User;

import java.util.List;

public class UserManager implements IUserManager {

    EntityManagerFactory factory = Persistence.createEntityManagerFactory("PolyOE");
    EntityManager em = factory.createEntityManager();

    // ===== 1. Tìm tất cả người dùng =====
    @Override
    public void findAll() {
        String jpql = "SELECT o FROM User o";
        TypedQuery<User> query = em.createQuery(jpql,User.class);
        List<User> list = query.getResultList();

        list.forEach(user -> {
            String fullname = user.getFullname();
            boolean admin = user.getAdmin();
            System.out.println(fullname + " : " + admin);
        });
    }

    // ===== 2. Tìm theo ID =====
    @Override
    public void findById(String userId) {
        User user = em.find(User.class, userId);
        if (user != null) {
            String fullname = user.getFullname();
            boolean admin = user.getAdmin();
            System.out.println(fullname + " : " + admin);
        } else {
            System.out.println("Không tìm thấy người dùng có ID: " + userId);
        }
    }

    // ===== 3. Thêm mới =====
    @Override
    public void create() {
        User user = new User("U01", "123", "teo@gmail.com", "Tèo", false);
        try {
            em.getTransaction().begin();
            em.persist(user);
            em.getTransaction().commit();
            System.out.println("Thêm mới thành công!");
        } catch (Exception e) {
            em.getTransaction().rollback();
            e.printStackTrace();
        }
    }

    // ===== 4. Cập nhật =====
    @Override
    public void update() {
        User user = em.find(User.class, "U01");
        if (user != null) {
            user.setFullname("Nguyễn Văn Tèo");
            user.setEmail("teonv@gmail.com");

            try {
                em.getTransaction().begin();
                em.merge(user);
                em.getTransaction().commit();
                System.out.println("Cập nhật thành công!");
            } catch (Exception e) {
                e.printStackTrace();
            }
        } else {
            System.out.println("Không tìm thấy người dùng để cập nhật!");
        }
    }

    // ===== 5. Xóa theo ID =====
    @Override
    public void deleteById(String userId) {
        User user = em.find(User.class, userId);
        if (user != null) {
            try {
                em.getTransaction().begin();
                em.remove(user);
                em.getTransaction().commit();
                System.out.println("Xóa thành công người dùng: " + userId);
            } catch (Exception e) {
                em.getTransaction().rollback();
                e.printStackTrace();
            }
        } else {
            System.out.println("Không tìm thấy người dùng để xóa!");
        }
    }
    @Override
    public void findByEmailDomainAndRole(String domain, Boolean isAdmin){
        String jpql = "SELECT o FROM User o WHERE o.email LIKE :search AND o.admin=:role";
        TypedQuery<User> query = em.createQuery(jpql, User.class);
        query.setParameter("search", "%" + domain);
        query.setParameter("role",isAdmin);
        List<User> list = query.getResultList();
        list.forEach(user -> {
            String name=user.getEmail();
            Boolean admin = user.getAdmin();
            System.out.println(name + " " +admin);

        });
    }



    @Override
    public List<User> findByPage(int pageNumber, int pageSize) {

        String jpql = "SELECT o FROM User o ORDER BY o.id";  // Nên ORDER BY để phân trang ổn định
        TypedQuery<User> query = em.createQuery(jpql, User.class);

        query.setFirstResult(pageNumber * pageSize);  // Vị trí bắt đầu
        query.setMaxResults(pageSize);                // Lấy tối đa 5 user

        List<User> list = query.getResultList();

        list.forEach(user -> {
            System.out.println(user.getFullname() + " : " + user.getAdmin());
        });
        return list;
    }




}
