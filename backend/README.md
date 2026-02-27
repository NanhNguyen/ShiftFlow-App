# Hệ Thống Quản Lý Lịch Trình - Backend

Đây là API backend cho **Hệ thống Quản lý Lịch trình cho Thực tập sinh**, được xây dựng bằng [NestJS](https://nestjs.com/) và [MongoDB](https://www.mongodb.com/). Hệ thống cung cấp một kiến trúc mạnh mẽ và có khả năng mở rộng để quản lý tài khoản người dùng, lịch trình và thông báo với phân quyền dựa trên vai trò (RBAC).

## 🚀 Công Nghệ

- **Framework:** [NestJS](https://nestjs.com/) (Node.js)
- **Ngôn ngữ:** [TypeScript](https://www.typescriptlang.org/)
- **Cơ sở dữ liệu:** [MongoDB](https://www.mongodb.com/) với [Mongoose](https://mongoosejs.com/)
- **Xác thực:** [Passport.js](https://www.passportjs.org/) với [JWT](https://jwt.io/)
- **Kiểm định dữ liệu:** [class-validator](https://github.com/typestack/class-validator) & [class-transformer](https://github.com/typestack/class-transformer)
- **Bảo mật:** [Bcrypt](https://github.com/kelektiv/node.bcrypt.js) để băm mật khẩu

## ✨ Tính Năng Chính

- **Xác thực & Phân quyền**:
  - Đăng nhập và đăng ký bảo mật dựa trên JWT.
  - Kiểm soát truy cập dựa trên vai trò (RBAC) với các vai trò: `Intern` (Thực tập sinh), `Manager` (Quản lý), và `HR` (Nhân sự).
- **Quản lý Lịch trình**:
  - Thực tập sinh có thể đăng ký và theo dõi lịch làm việc hàng tuần.
  - Quản lý có thể xem, phê duyệt hoặc từ chối lịch trình của thực tập sinh.
  - Nhân sự có thể giám sát tất cả lịch trình và yêu cầu.
- **Quản lý Người dùng**:
  - Quản lý hồ sơ và gán vai trò.
- **Thông báo**:
  - Hệ thống tự động cập nhật các thay đổi liên quan đến lịch trình.
- **Toàn vẹn Dữ liệu**:
  - Cấu hình dựa trên môi trường (.env).
  - Các script gieo mầm dữ liệu (seeding) và di cư (migration).

## 📁 Cấu Trúc Dự Án

```text
src/
├── auth/           # Logic xác thực (Đăng nhập, Chiến lược JWT, Guards)
├── users/          # Quản lý người dùng (Schema, Service, Controller)
├── schedules/      # Quản lý lịch trình (Logic nghiệp vụ cho ca làm)
├── notifications/  # Dịch vụ thông báo
├── app.module.ts   # Module chính của ứng dụng
└── main.ts         # Điểm khởi đầu của ứng dụng
```

## 🛠️ Bắt Đầu

### Yêu cầu hệ thống

- Node.js (v18+)
- MongoDB (Local hoặc Atlas)
- npm hoặc yarn

### Cài đặt

1. Clone repository và di chuyển vào thư mục `backend`.
2. Cài đặt các phụ thuộc:
   ```bash
   npm install
   ```
3. Tạo file `.env` trong thư mục gốc và cấu hình các biến sau:
   ```env
   MONGODB_URI=link_ket_noi_mongodb_cua_ban
   JWT_SECRET=ma_bi_mat_jwt_cua_ban
   PORT=3000
   ```

### Chạy Dự Án

```bash
# Chế độ phát triển (watch mode)
npm run start:dev

# Chế độ production
npm run build
npm run start:prod
```

### Các Script Tiện Ích

```bash
# Gieo mầm dữ liệu ban đầu (vai trò và người dùng mẫu)
npm run seed

# Kiểm tra kết nối cơ sở dữ liệu
npm run check-db

# Tạo người dùng thử nghiệm
npm run create-test-user
```

## 🧪 Kiểm Thử

```bash
# Unit tests
npm run test

# End-to-end tests
npm run test:e2e

# Test coverage
npm run test:cov
```

---
Được phát triển cho **Chương trình Thực tập IT tại NetSpace**.
