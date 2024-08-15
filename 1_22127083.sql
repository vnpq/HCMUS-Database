use QLDETAI
go 

-- 1
select distinct detai.*
from DETAI
join GIAOVIEN on DETAI.GVCNDT = GIAOVIEN.MAGV
join GV_DT on GIAOVIEN.MAGV = GV_DT.MAGV

-- 2
select gv1.*
from GIAOVIEN as gv1
where not exists (
    select detai.MADT
    from detai 
    join chude on detai.MACD = chude.MACD
    where chude.TENCD = N'Quản lý giáo dục'
    except 
    select distinct detai.MADT
    from detai
    join THAMGIADT on detai.MADT = THAMGIADT.MADT
    where THAMGIADT.MAGV = gv1.MAGV
)

-- 3
go
create FUNCTION fnGetMaKhoa(@magv char(5)) returns char(5)
as 
begin 
    declare @makhoa char(5)
    
    select @makhoa = khoa.MAKHOA
    from GIAOVIEN 
    join bomon on GIAOVIEN.MABM = bomon.MABM
    join khoa on bomon.MAKHOA = khoa.MAKHOA
    where MAGV = @magv

    return @makhoa
end 
go
create function fnComapreDate(@month int, @year int, @date Date) returns int
as
begin
    declare @result int

    if (@year < year(@date))
        set @result = -1
    else if (@year > year(@date))
        set @result = 1
    else if (@month < month(@date))
        set @result = -1
    else if (@month > month(@date))
        set @result = 1
    else
        set @result = 0

    return @result
end
go
CREATE FUNCTION fnDem_SLCongViec_Khoa1(@makhoa char(5), @thang int, @nam int)
RETURNS int
AS
BEGIN
    DECLARE @result int
    
    select @result = count(*)
    from detai 
    join congviec on detai.MADT = congviec.MADT
    where dbo.fnGetMaKhoa(detai.GVCNDT) = @makhoa
    and dbo.fnComapreDate(@thang, @nam, congviec.NGAYbd) >= 0 
    and dbo.fnComapreDate(@thang, @nam, congviec.NGAYkt) <= 0

    RETURN @result
END

--  go 
declare @result1 int, @result int
set @result1 = dbo.fnDem_SLCongViec_Khoa('CNTT', 5, 2008)
print @result1
set @result = dbo.fnDem_SLCongViec_Khoa('CNTT', 5, 2008);
print @result;
-- 4

go
create PROCEDURE spTK_SLCongViec_Khoa
    @makhoa char(5),
    @nam int,
    @tongThongke int OUTPUT
as 
begin
    declare @i int 
    declare @currentYear int
    select @currentYear = year(getdate())
    if @nam > @currentYear
    begin
        RAISERROR('Nam khong hop le', 16, 1)
        return
    end
    if not exists (select * from KHOA where MAKHOA = @makhoa) 
    begin 
        RAISERROR('Ma khoa khong ton tai', 16, 1)
        return
    end
    set @i = 1
    set @tongThongke = 0
    while @i <= 12
    begin
        declare @slCongviec int 
        set @slCongviec = dbo.fnDem_SLCongViec_Khoa(@makhoa, @i, @nam)
        if @slCongviec > 0 
        begin 
            set @tongThongke = @tongThongke + @slCongviec
            print 'Thang ' + cast(@i as nvarchar) + ': ' + cast(@slCongviec as nvarchar) + ' cong viec'
        end
        set @i = @i + 1
    end
end

--  go
--  declare @tongThongke int
--  exec spTK_SLCongViec_Khoa 'SH', 2007, @tongThongke OUTPUT

--  print 'Tong so luong cong viec thong ke: ' + cast(@tongThongke as nvarchar)