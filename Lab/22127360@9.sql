use QLGiaoVienThamGiaDeTai;
go

--Q1
select BM.MABM, BM.TENBM, count(distinct gv.MAGV) as 'SL GV co SDT'
from BOMON BM join GIAOVIEN GV on BM.MABM = GV.MABM
	join GV_DT SDT on GV.MAGV = SDT.MAGV
group by BM.MABM, BM.TENBM
having count(distinct GV.MAGV) >= ALL (
	select count(distinct GV.MAGV)
	from BOMON BM join GIAOVIEN GV on BM.MABM = GV.MABM
		join GV_DT SDT on GV.MAGV = SDT.MAGV
	group by BM.MABM, BM.TENBM
);
go

--Q2
select distinct GV.HOTEN
from GIAOVIEN GV
where not exists (
	select MADT 
	from DETAI DT join GIAOVIEN GV2 on DT.GVCNDT = GV2.MAGV
	where GV2.HOTEN = N'Trần Trà Hương'
except
	select MADT
	from THAMGIADT TG
	where TG.MAGV = GV.MAGV
);
	
--Q3
select distinct GV.HOTEN
from GIAOVIEN GV
where GV.MAGV in (
	select GV.MAGV
	from GIAOVIEN GV, DETAI DT, THAMGIADT TG
	where GV.MAGV = TG.MAGV and TG.MADT = DT.MADT and DT.KINHPHI >= 80
	group by GV.MAGV
	having count(distinct DT.MADT)  = (select count(distinct MADT)
										from THAMGIADT TG2 where TG2.MAGV = GV.MAGV)
);
go;

--Q4
create or alter function fnLay_DSDeTai_GVThamGia 
	(@maGV char(10), @startDate date, @endDate date)
returns table
as
return 
	select TG.MADT, DT.TENDT, count(distinct CV.STT) as 'SL Cong viec'
	from THAMGIADT TG, CONGVIEC CV, DETAI DT
	where TG.MADT = CV.MADT	
		and TG.MAGV = @maGV 
		and TG.MADT = DT.MADT
		and CV.NGAYBD >= @startDate
		and CV.NGAYKT <= @endDate
	group by TG.MADT, DT.TENDT
	having count(distinct CV.STT) >= 2;
go

SELECT * FROM fnLay_DSDeTai_GVThamGia('001', '01/01/2001', '12/01/2009');
GO

--Q5
create or alter procedure spHienThi_DSCongViec_GVThamGia
	(@maGV char(10), @startDate date, @endDate date)
as
begin
	-- Kiểm tra các điều kiện đầu vào
	if not exists (select * from GIAOVIEN where MAGV = @maGV)
	begin
		raiserror(N'Không tồn tại mã GV hợp lệ', 16, 1);
		return;
	end

	if (@startDate > @endDate)
	begin
		raiserror(N'Khoảng ngày không hợp lệ', 16, 1);
		return;
	end
	--Xác định số đề tài tham gia thông qua hàm ở câu 4
	declare @SL_DeTai int;
	select @SL_DeTai = count(distinct tb.MADT) from fnLay_DSDeTai_GVThamGia(@maGV, @startDate, @endDate) as tb;
	--In số lượng đề tài thỏa yêu cầu, nếu = 0 thì kết thúc
	print concat(N'Số lượng đề tài là: ', @SL_DeTai);
	if (@SL_DeTai = 0 )
		return;
	--Xuất các công việc thuộc đề tài lấy từ câu trên
	select CV.*
	from CONGVIEC CV, fnLay_DSDeTai_GVThamGia(@maGV, @startDate, @endDate) as DT, THAMGIADT TG
	where CV.MADT = DT.MADT and TG.MADT = DT.MADT
		and TG.MAGV = @maGV;
end
go

exec spHienThi_DSCongViec_GVThamGia '002', '01/01/2001', '12/01/2009';
go