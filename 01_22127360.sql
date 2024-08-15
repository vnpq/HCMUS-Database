--Họ và tên: Võ Nguyễn Phương Quỳnh
--MSSV: 22127360
--Vị trí ngồi: H1C1
--Mã đề: 01

use QLGiaoVienThamGiaDeTai;
go

--Câu 1 
select DT.TENDT, DT.MADT
from DETAI DT join GIAOVIEN GV on DT.GVCNDT = GV.MAGV
	join GV_DT D on GV.MAGV = D.MAGV
group by DT.TENDT, DT.MADT
having count(distinct D.DIENTHOAI) >=1;
go

--Câu 2
select distinct GV.*
from GIAOVIEN GV
where not exists (
	select MADT 
	from DETAI DT join CHUDE CD on DT.MACD = CD.MACD
	where CD.TENCD = N'Quản lý giáo dục'
except
	select MADT
	from THAMGIADT TG
	where TG.MAGV = GV.MAGV
);
go

--Câu 3
create or alter function fnDem_SLCongViec_Khoa
	(@MAKHOA char(5), @Thang int, @Nam int)
returns int
as
begin
	declare @startDate date;
	declare @endDate date;
	declare @result int;
	select @result = count(distinct CV.STT) 
	from BOMON BM, DETAI DT, GIAOVIEN GV, CONGVIEC CV
	where CV.MADT = DT.MADT and
		DT.GVCNDT = GV.MAGV and
		GV.MABM = BM.MABM and
		BM.MAKHOA = @MAKHOA and
		(month(CV.NGAYBD) = @Thang and
		year(CV.NGAYBD) = @Nam) or
		(month(CV.NGAYKT) = @Thang and
		year(CV.NGAYKT) = @Nam);
	return @result;
end
go

--print dbo.fnDem_SLCongViec_Khoa('CNTT', 5, 2008);

--Câu 4
create or alter procedure spTK_SLCongViec_Khoa
	(@MAKHOA char(5), @Nam int)
as
begin
	-- Kiểm tra các điều kiện đầu vào
	if not exists (select * from KHOA where MAKHOA = @MAKHOA)
	begin
		raiserror(N'Không tồn tại mã khoa hợp lệ', 16, 1);
		return;
	end

	if ( @Nam > year(getdate()) )
	begin
		raiserror(N'Năm không hợp lệ', 16, 1);
		return;
	end

	--Thực hiện yêu cầu
	declare @Thang int
	set @Thang = 1;
	print (N'Tháng SLCV');
	while (@Thang <=12)
	begin
		declare @num int;
		set @num = dbo.fnDem_SLCongViec_Khoa(@MAKHOA, @Thang, @Nam);
		if (@num != 0) 
		begin
			print concat(@Thang, '      ', @num);
		end
		set @Thang = @Thang + 1;
	end
end
go

--exec spTK_SLCongViec_Khoa 'CNTT', 2008
--go