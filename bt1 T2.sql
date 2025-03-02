
USE QLST02
SET DATEFORMAT DMY
CREATE TABLE NhomSanPham( MANHOM INT NOT NULL PRIMARY KEY,
	TenNhom NVARCHAR(15));
CREATE TABLE NhaCungCap (MaNCC INT NOT NULL PRIMARY KEY,
	TenNcc NVARCHAR(40) NOT NULL,
	Diachi NVARCHAR(60),
	Phone NVARCHAR(24),
	SoFax NVARCHAR(24),
	DCMail NVARCHAR(50));
CREATE TABLE SanPham (MaSp INT NOT NULL PRIMARY KEY,
	TenSp NVARCHAR(40) NOT NULL,
	MaNCC INT,
	MoTa NVARCHAR(50),
	MaNhom INT,
	Donvitinh NVARCHAR(20),
	GiaGoc MONEY CHECK (GiaGoc > 0),
	SLTON INT CHECK (SLTON > 0),
	CONSTRAINT FK_SanPham_Nhom FOREIGN KEY (MaNhom) REFERENCES NhomSanPham(MANHOM),
    CONSTRAINT FK_SanPham_NCC FOREIGN KEY (MaNCC) REFERENCES NhaCungCap(MaNCC));
CREATE TABLE HoaDon (MaHD INT NOT NULL,
	NgayLapHD DATETIME, 
	NgayGiao DATETIME,
	Noichuyen NVARCHAR(60) NOT NULL,
	MaKh NCHAR(5));
CREATE TABLE CT_HoaDon (MaHD INT NOT NULL,
	MaSp INT NOT NULL,
	Soluong INT CHECK (Soluong > 0),
	Dongia MONEY,
	ChietKhau MONEY CHECK (ChietKhau >= 0));
CREATE TABLE KhachHang (MaKh NCHAR(5) NOT NULL,
	TenKh NVARCHAR(40) NOT NULL,
	LoaiKh NVARCHAR(3) CHECK (LoaiKh IN ('VIP','TV','VL')),
	DiaChi NVARCHAR(60),
	Phone NVARCHAR(24),
	SoFax NVARCHAR(24),
	DCMail NVARCHAR(50),
	DiemTL INT CHECK (DiemTL >= 0));
	--- b) THÊM KHÓA CHÍNH CHO 3 TABLE
ALTER TABLE KhachHang ADD CONSTRAINT PK_KhachHang PRIMARY KEY (MaKh);
ALTER TABLE HoaDon ADD CONSTRAINT Pk_HoaDon PRIMARY KEY (MaHD);
ALTER TABLE CT_HoaDon ADD CONSTRAINT Pk_CTHoaDon PRIMARY KEY (MaHD, MaSp);
--- C) THÊM KHÓA NGOẠI CHO 3 TABLE
ALTER TABLE HoaDon ADD CONSTRAINT FK_HoaDON_KhachHang FOREIGN KEY (MaKh) REFERENCES KhachHang(MaKh);
ALTER TABLE CT_HoaDon ADD CONSTRAINT FK_CT_HoaDon_HoaDon FOREIGN KEY (MaHD) REFERENCES HoaDon(MaHD);
ALTER TABLE CT_HoaDon ADD CONSTRAINT FK_CT_HoaDon_SanPham FOREIGN KEY (MaSp) REFERENCES SanPham(MaSp);
--- d) Alter Table … khai báo các ràng buộc miền giá trị (Check Constraint) và ràng buộc giá trị mặc định:
ALTER TABLE HoaDon  ADD CONSTRAINT DF_NgayLapHD DEFAULT GETDATE() FOR NgayLapHD;
--- e) LoaiHD vào bảng HOADON, có kiểu dữ liệu char(1), Chỉ nhập N(Nhập), X(Xuất), C(Chuyển từ cửa hàng này sang cửa hàng khác), T (Trả), giá trị mặc định là ‘N’.
ALTER TABLE HoaDon ADD LoaiHD CHAR(1) NOT NULL DEFAULT 'N';
ALTER TABLE HoaDon ADD CONSTRAINT CK_LoaiHD CHECK (LoaiHD IN ('N', 'X', 'C', 'T'));
---f) ràng buộc cho bảng HoaDon với yêu cầu NgayGiao>=NgayLapHD
ALTER TABLE HoaDon ADD CONSTRAINT CK_NgayGiao CHECK (NgayGiao >= NgayLapHD);