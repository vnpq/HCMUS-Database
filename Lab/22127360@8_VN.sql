CREATE DATABASE QLKHACHSAN;
GO

USE QLKHACHSAN;
GO

-- Tạo bảng PHÒNG
CREATE TABLE PHONG (
    MaPhong CHAR(10) PRIMARY KEY,
    TinhTrang NCHAR(50),
    LoaiPhong NCHAR(50),
    DonGia INT
);
go

-- Tạo bảng KHÁCH HÀNG
CREATE TABLE KHACHHANG (
    MaKH CHAR(10) PRIMARY KEY,
    HoTen NCHAR(100),
    DiaChi NCHAR(100),
    DienThoai CHAR(15)
);
go

-- Tạo bảng ĐẶT PHÒNG
CREATE TABLE DATPHONG (
    MaDat CHAR(10) PRIMARY KEY,
    MaKH CHAR(10),
    MaPhong CHAR(10),
    NgayDat DATE,
    NgayTra DATE NULL,
    ThanhTien INT NULL,
    FOREIGN KEY (MaKH) REFERENCES KHACHHANG(MaKH),
    FOREIGN KEY (MaPhong) REFERENCES PHONG(MaPhong)
);
go

--1

create procedure spDatPhong	@maKH char(10), @maPhong char(10), @ngaydat date
as
begin
	declare @ma char(10);

	--Kiểm tra mã khách hàng phải hợp lệ (phải xuất hiện trong bảng KHÁCH HÀNG)
	if not exists (select * from KHACHHANG where @maKH = MaKH)
	begin
		print(N'Mã khách hàng không tồn tại');
		return;
	end;
	
	--Kiểm tra mã phòng hợp lệ (phải xuất hiện trong bảng PHÒNG)
	if not exists (select * from PHONG where @maPhong = MaPhong)
	begin
		print(N'Mã phòng không tồn tại');
		return;
	end;

	--Chỉ được đặt phòng khi tình trạng của phòng là “Rảnh”
	if ((select TinhTrang from PHONG where @maPhong = MaPhong) like N'%Bận%')
		or (exists (select * from DATPHONG where MaPhong = @maPhong AND NgayTra IS NULL))
	begin
		print (N'Phòng đang bận');
		return;
	end;
	
	--Tạo mã đặt mới
	select @ma = RIGHT('000' + CAST(ISNULL(MAX(CAST(RIGHT(MaDat, 10) AS INT)), 0) + 1 AS VARCHAR(10)), 10)
    from DATPHONG;

	--Ghi nhận thông tin đặt phòng xuống CSDL (Ngày trả và thành tiền của khi đặt phòng là NULL)
	insert into DATPHONG values (@ma, @maKH, @maPhong, @ngaydat, NULL, NULL);

	--Sau khi đặt phòng thành công thì phải cập nhật tình trạng của phòng là “Bận”
	update PHONG set TinhTrang = N'Bận' where MaPhong = @maPhong;
	print N'Đặt phòng thành công';

end;
go 

--2
create procedure spTraPhong @maDat char(10), @maKH char(10)
as
begin
	--Khai báo các biến cần thiết
	declare @ngayTra date;
	declare @soNgay int;
	declare @thanhTien int;

	--Kiểm tra tính hợp lệ của mã đặt phòng, mã khách hàng: Hợp lệ nếu khách hàng có thực hiện việc đặt phòng.
	if (not exists (select * from DATPHONG where @maDat = MaDat and @maKH = MaKH))
	begin 
		print N'Thông tin không hợp lệ';
		return;
	end;

	--Ngày trả phòng chính là ngày hiện hành.
	set @ngayTra = GETDATE();

	--Tiền thanh toán được tính theo công thức: Tien = Số ngày mượn x đơn giá của phòng.
	select @soNgay = DATEDIFF(day, NgayDat, @ngayTra) from DATPHONG where @maDat = MaDat;
	select @thanhTien = @soNgay * DonGia from PHONG where MaPhong = (select MaPhong from DATPHONG where MaDat = @maDat);

	--Ghi nhận thông tin trả phòng, Cập nhật tình trạng phòng là 'Rãnh'
	update DATPHONG
		set NgayTra = @ngayTra,
			ThanhTien = @thanhTien
	where MaDat = @maDat;

	update PHONG
		set TinhTrang = N'Rãnh'
	where MaPhong = (select MaPhong from DATPHONG where MaDat = @maDat);

	print N'Trả phòng thành công!';
end;
go
