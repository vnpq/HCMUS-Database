use QLTSinh;
go

--Q1
select K.MaKhoi, K.TenKhoi, count(distinct TS.SBD) as 'SL thi sinh'
from Khoi K join ThiSinh TS on TS.Khoi = K.MaKhoi
where TS.NoiHocPTTH like '%Dong Nai%'
group by K.MaKhoi, K.TenKhoi
having count (distinct TS.SBD) >= ALL (select count(distinct TS.SBD) as 'SL thi sinh'
		from Khoi K join ThiSinh TS on TS.Khoi = K.MaKhoi
		where TS.NoiHocPTTH like '%Dong Nai%'
	group by K.MaKhoi, K.TenKhoi
);
go

--Q2
select N.MaNganh, N.TenNganh, TS.HoTen, sum(DT.Diem) as Diem
from Nganh N join ThiSinh TS on TS.Nganh = N.MaNganh
	join DuThi DT on DT.SBD = TS.SBD 
group by N.MaNganh, N.TenNganh, TS.HoTen
having sum(DT.Diem) >= all (select sum(DT.Diem)
	from Nganh N1 join ThiSinh TS on TS.Nganh = N1.MaNganh
		join DuThi DT on DT.SBD = TS.SBD 
	where N.MaNganh = N1.MaNganh
	group by N1.MaNganh, TS.SBD
);
go

--Q3
select distinct NK.MaKhoi
from Nganh_Khoi NK
where not exists ( 
	select N.MaNganh
	from Nganh N where TenNganh like '%Cong nghe%'
except 
	select MaNganh
	from Nganh_Khoi
	where MaKhoi = NK.MaKhoi
);
go

--Q4