--Huỳnh Minh Quang
--21127149

--DROP PROC Sum3
--a. In ra câu chào "Hello World !!!"
CREATE PROCEDURE HelloWorld
AS 
BEGIN
	PRINT 'Hello World'
END
EXEC HelloWorld

--b. In ra tổng 2 số
CREATE PROCEDURE NumSum
    @num1 INT,
    @num2 INT
AS
BEGIN
    SELECT @num1 + @num2 AS SumResult
END
EXEC NumSum 1, 2

--c. Tính tổng 2 số (sử dụng biến output để lưu kết quả trả về )
CREATE PROCEDURE SumC
    @num1 INT,
    @num2 INT,	
    @result INT OUTPUT
AS
BEGIN
    SET @result = @num1 + @num2;
END

DECLARE @result INT
EXEC SumC 4, 6, @result OUT
PRINT @result

--d. In tổng 3 số (sử dụng blại stored procedure tính tổng 2 số)
CREATE PROCEDURE Sum3
    @num1 INT,
    @num2 INT,
    @num3 INT,
    @result INT OUTPUT
AS
BEGIN
    DECLARE @tempResult INT;

    -- Gọi stored procedure tính tổng 2 số cho 2 lần để tính tổng 3 số
    EXEC SumC @num1, @num2, @tempResult OUTPUT;
    EXEC SumC @tempResult, @num3, @result OUTPUT;
	PRINT @result
END

DECLARE @result INT
EXEC Sum3 5, 6, 6, @result OUT

--e. In ra tổng các số nguyên từ m đến n
CREATE PROCEDURE ToltalMN
    @m INT,
    @n INT
AS
BEGIN
    DECLARE @sum INT = 0;
    
    WHILE @m <= @n
    BEGIN
        SET @sum = @sum + @m;
        SET @m = @m + 1;
    END;

    SELECT @sum AS TotalSum;
END

EXEC ToltalMN 3, 5

--f. Kiểm tra 1 số nguyên có phải là số nguyên tố hay không 
CREATE PROCEDURE KTNguyenTo
    @n INT,
    @KT BIT OUTPUT
AS
BEGIN
    DECLARE @i INT = 2;
    SET @KT = 1;

    WHILE @i <= SQRT(@n)
    BEGIN
        IF @n % @i = 0
        BEGIN
            SET @KT = 0;
            BREAK;
        END;
        SET @i = @i + 1;
    END;
	
END;

DECLARE @KT INT
EXEC KTNguyenTo 5, @KT OUT
IF @KT = 1
		PRINT N'Là số nguyên tố';
	ELSE
		PRINT N'Không là số nguyên tố';

--g. In ra tổng các số nguyên tố trong đoạn m, n
CREATE PROCEDURE ToltalSNT
    @m INT,
    @n INT
AS
BEGIN
    DECLARE @sum INT = 0;
    DECLARE @KT BIT;

    WHILE @m <= @n
    BEGIN
        EXEC KTNguyenTo @m, @KT OUTPUT;
        IF @KT = 1
            SET @sum = @sum + @m;
        SET @m = @m + 1;
    END;

    SELECT @sum AS N'Tổng số nguyên tố';
END;

EXEC ToltalSNT 1, 10

--h. Tính ước chung lớn nhất của 2 số nguyên
CREATE PROCEDURE GCD
    @n INT,
    @m INT,
    @gcd INT OUTPUT
AS
BEGIN
    DECLARE @a INT, @b INT, @r INT;
    SET @a = @n;
    SET @b = @m;

    WHILE @b <> 0
    BEGIN
        SET @r = @a % @b;
        SET @a = @b;
        SET @b = @r;
    END;

    SET @gcd = @a;
END;

DECLARE @gcd INT
EXEC GCD 5, 10, @gcd OUT
PRINT @gcd

--i. Tính bội chung nhỏ nhất của 2 số nguyên 
CREATE PROCEDURE LCM
    @n INT,
    @m INT,
    @lcm INT OUTPUT
AS
BEGIN
    DECLARE @gcd INT;
    EXEC GCD @n, @m, @gcd OUTPUT;
    SET @lcm = (@n * @m) / @gcd;
END;

DECLARE @lcm INT
EXEC LCM 4, 6, @lcm OUT
PRINT @lcm

-----------------
USE QLDT
--j. Xuất ra toàn bộ danh sách giáo viên 
CREATE PROCEDURE GetGV
AS
BEGIN
    SELECT * FROM GIAOVIEN;
END;

EXEC GetGV

--k. Tính số lượng đề tài mà một giáo viên đang thực hiện 
CREATE PROCEDURE SLDT
    @MGV VARCHAR(3)
AS
BEGIN
    SELECT  COUNT(DISTINCT TGDT.MADT) AS SLDT
    FROM THAMGIADT TGDT
    WHERE TGDT.MAGV = @MGV;
END;

EXEC SLDT '003'

--l. In thông tin chi tiết của một giáo viên (sử dụng lệnh print): Thôn tin cá nhân, số lượng đề tài tham gia, số lượn nhân thân của giáo viên đó 
CREATE PROCEDURE TTGV
    @MAGV VARCHAR(3)
AS
BEGIN
    DECLARE @TTCN NVARCHAR(MAX);
    DECLARE @SLDTTG INT;
    DECLARE @SLNT INT;

    -- Lấy thông tin cá nhân
    SELECT @TTCN = CONCAT('HOTEN: ', GV.HOTEN, ', Dia chi: ', GV.DIACHI, ', Ngay sinh: ', GV.NGAYSINH)
    FROM GIAOVIEN GV
    WHERE MAGV = @MAGV;

    -- Lấy số lượng đề tài tham gia
    SELECT @SLDTTG = COUNT(DISTINCT TGDT.MADT)
    FROM THAMGIADT TGDT
    WHERE MAGV = @MAGV;

    -- Lấy số lượng nhân thân
    SELECT @SLNT = COUNT(*)
    FROM NGUOITHAN
    WHERE MAGV = @MAGV;

    -- In thông tin
    PRINT @TTCN;
    PRINT CONCAT('SLDTTG: ', @SLDTTG);
    PRINT CONCAT('SLNT: ', @SLNT)
END;

EXEC TTGV '001'

--m. Kiểm tra một giáo viên có tồn tại hay không (dựa vào MGV)
CREATE PROCEDURE KTGV
    @MAGV VARCHAR(3) 
AS
BEGIN
    IF EXISTS (SELECT 1 
			   FROM GIAOVIEN 
			   WHERE MAGV = @MAGV)
        PRINT N'Giáo viên đã tồn tại.'
    ELSE
        PRINT N'Giáo viên không tồn tại.'
END;

EXEC KTGV '001'

--n. Kiểm tra quy định của một giáo viên: chỉ thực hiện các đề tài mà bộ môn của giáo viên đó làm chủ nhiệm
CREATE PROCEDURE KTQDGV
    @MAGV VARCHAR(3)
AS
BEGIN
    DECLARE @MABM VARCHAR(5);

    -- Lấy mã bộ môn của giáo viên
    SELECT @MABM = GV.MABM
    FROM GIAOVIEN GV
    WHERE GV.MAGV = @MAGV;

    -- Kiểm tra các đề tài không thuộc bộ môn của giáo viên
    IF EXISTS (
        SELECT TGDT.MADT
        FROM THAMGIADT TGDT	
        JOIN DETAI DT ON TGDT.MADT = DT.MADT
		JOIN GIAOVIEN GV ON DT.GVCNDT = GV.MAGV
        WHERE TGDT.MAGV = @MAGV AND GV.MABM <> @MABM)

        PRINT N'Giáo viên không tuân thủ quy định.'
    ELSE
        PRINT N'Giáo viên tuân thủ quy định.';
END;

DROP PROC KTQDGV
EXEC KTQDGV '002'

--o. Thực hiện thêm một phân công cho giáo viên thực hiện một  công việc đề tài 
--kiểm tra đầu vào hợp lệ: giáo viên phỉ tồn tại, thời gian tham gia > 0
--kiemr tra quy định ở câu n

--q.Thực hiện xóa một giáo viên theo mã. Nếu giáo viên có thông tin liên quan ( có nhân thân có làm đề tài) thì báo lỗi
CREATE PROCEDURE XOAGV
    @MAGV VARCHAR(3)
AS
BEGIN
    DECLARE @KT BIT;
	SET @KT=1

	IF (@MAGV IN (SELECT MAGV
				  FROM THAMGIADT))
		SET @KT = 0
	
	if(@MAGV in ( SELECT MAGV
				  FROM NGUOITHAN))
		SET @KT = 0

	if(@MAGV in (SELECT GVQLCM
				 FROM GIAOVIEN))
		SET @KT = 0

	if(@MAGV in (SELECT TRUONGBM
				 FROM BOMON))
		SET @KT = 0

	if(@MAGV in (SELECT TRUONGKHOA
				 FROM KHOA))
		SET @KT = 0
	
	-- lam chu nhiem de tai
	if(@MAGV in (SELECT GVCNDT
				 FROM DETAI))
		SET @KT = 0

	if(@KT = 1)
	BEGIN
		DELETE FROM GIAOVIEN
		WHERE MAGV = @MAGV
		print 'Xoa thanh cong'
	END
	ELSE
		PRINT 'Khong the xoa'
END

EXEC XOAGV '001'


--r. Kiểm tra quy định của 2 giáo viên a, b: nếu a là trưởng bộ môn c của b thì lương của a phải lớn hơn của b (a, b là MAGV)
CREATE PROCEDURE CHECKGV
	@MAGV1 char(3),
	@MAGV2 char(3)
AS
BEGIN
	DECLARE @KT BIT
	SET @KT = 1
	IF ( @MAGV1 IN (SELECT BM.TRUONGBM
		           FROM  GIAOVIEN GV 
				   JOIN BOMON BM on GV.MABM = BM.MABM
				   WHERE GV.MAGV = @MAGV2))
	BEGIN
		DECLARE @luong1 numeric(6, 1), @luong2 numeric(6, 1)
		SELECT @luong1 = LUONG
		FROM GIAOVIEN
		WHERE MAGV = @MAGV1;
		SELECT @luong2 = luong
		FROM GIAOVIEN
		WHERE MAGV = @MAGV2;
		IF (@luong1 <= @luong2)
			SET @KT = 0
	END

	IF(@KT = 1)
		PRINT 'Dung quy dinh'
	ELSE
		PRINT 'Sai quy dinh'
END;

EXEC CHECKGV '002', '003'
 
--S. Thêm một giáo viên: Kiểm tra các quy định: Không trùng tên, tuổi > 18, lương >0

--t. Mã giáo viên xác định tự động theo quy tắc: 
--nếu đã có giáo viên 001, 002, 003 thì MAGV của gv mới là 004.
--Nếu đã có gv 001, 002, 005 thì MAGV mới là 003
CREATE PROCEDURE AutoMAGV
AS
BEGIN
    DECLARE @NewMAGV VARCHAR(3);

    -- Tìm mã giáo viên tiếp theo dựa trên quy tắc
    SELECT @NextID = ISNULL(MIN(MAGV) - 1, 1)
    FROM GIAOVIEN
    WHERE MAGV NOT IN (SELECT DISTINCT MAGV FROM GIAOVIEN);

    PRINT N'Mã giáo viên mới: ' + RIGHT('000' + CAST(@NextID AS NVARCHAR(3)), 3);
END;

DROP PROC AutoMAGV

EXEC AutoMAGV













