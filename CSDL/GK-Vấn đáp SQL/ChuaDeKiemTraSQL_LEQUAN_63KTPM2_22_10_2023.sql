--author Le Quan 63KTPM2
--Date: 21/10/2023

create database chuade
use chuade

create table COQUAN(
MaCQ varchar(10) not null primary key, 
DiachiCQ nvarchar(50))

create table CANBO(
MaCB varchar(10) not null primary key,
TenCB nvarchar(30),
SoNamCTac int,
DiaChi nvarchar(50),
MaCQ varchar(10) foreign key (MaCQ) references COQUAN(MaCQ))

insert into COQUAN
values('A1',N'Hà Nội'),
('A2',N'Hà Nam')

insert into CANBO
values('CB1',N'Nguyễn Văn A',10,N'Vĩnh Phúc','A1'),
('CB2',N'Lê Văn B',7,N'Bắc Giang','A1'),
('CB3',N'Trần Thị C',3,N'Hòa Bình','A1'),
('CB4',N'Phạm Văn D',1,N'Hòa Bình','A2'),
('CB5',N'Hoàng Thị E',2,N'Vĩnh Phúc','A2')

insert into CANBO
values('CB6',N'Nguyễn Văn F',10,N'Hà Nội','A2'),
('CB7',N'Lê Văn G',7,N'Hà Nội','A2')

--Đề 3
--Cho biết tổng số cán bộ của mỗi cơ quan

SELECT a.MaCQ, COUNT(*) AS 'Tổng số cán bộ'
FROM COQUAN a
INNER JOIN CANBO b ON a.MaCQ = b.MaCQ
GROUP BY a.MaCQ

--Cho biết mã cán bộ, tên cán bộ của các cán bộ có số năm công tác nhiều nhất

select MaCB,TenCB
from CANBO
where SoNamCTac >= all(select SoNamCTac from CANBO)

--Cho biết tên cán bộ và địa chỉ cơ quan của tất cả các cán bộ có địa chỉ là Hà Nội
select TenCB, DiaChi
from CANBO
where DiaChi=N'Hà Nội'


create table SACH(
MaSach varchar(10) not null primary key,
TenSach nvarchar(30),
TenNXB nvarchar(30))

create table DOC_GIA(
Sothe varchar(10) not null primary key,
HoTen nvarchar(30),
DiaChi nvarchar(30),
DienThoai varchar(10))

create table MUON_SACH(
MaSach varchar(10) foreign key (MaSach) references SACH(MaSach),
SoThe varchar(10) foreign key (Sothe) references DOC_GIA(Sothe),
NgayMuon date,
NgayTra date)

insert into SACH
values('S1',N'Sách A','NXB A'),
('S2',N'Sách B','NXB B'),
('S3',N'Sách C','NXB C')

insert into DOC_GIA
values('T1',N'Nguyễn Văn A',N'Thanh Hóa','034578512'),
('T2',N'Nguyễn Văn B',N'Hà Nội','034578513'),
('T3',N'Lê Văn C',N'Hưng Yên','094578512')

insert into DOC_GIA
values('T4',N'Nguyễn Văn K',N'Thanh Hóa','036788512')

insert into MUON_SACH
values('S1','T1','2022-05-30','2022-06-1'),
('S1','T2','2022-12-30','2023-01-15'),
('S2','T1','2022-03-19','2022-03-25'),
('S2','T2','2022-02-13','2022-06-1')

insert into MUON_SACH
values('S1','T3','2020-05-30','2020-06-1')
insert into MUON_SACH
values('S1','T1','2021-10-30','2021-12-1')
insert into MUON_SACH
values('S1','T1','2021-10-30','2021-11-15')
insert into MUON_SACH
values('S1','T1','2020-02-01','2020-03-20')
insert into MUON_SACH
values('S1','T1','2020-02-01','2021-10-20')


--Đưa ra thông tin những quyển sách chưa từng được mượn
select MaSach, TenSach, TenNXB
from SACH
except
select a.MaSach, a.TenSach, a.TenNXB
from SACH a INNER JOIN MUON_SACH b on a.MaSach = b.MaSach;

--Thống kê số độc giả từng mượn sách theo từng tên sách

select c.TenSach, count(*) as 'Số độc giả mượn'
from DOC_GIA a inner join MUON_SACH b on a.Sothe = b.SoThe inner join SACH c on b.MaSach = c.MaSach
group by c.TenSach

--Đưa ra thông tin số đầu sách theo từng nhà xuất bản
select TenNXB, count(*) as 'Số đầu sách'
from SACH
group by TenNXB

--Đưa ra tên của các độc giả đã mượn sách
select distinct(a.HoTen)
from DOC_GIA a
inner join MUON_SACH b on a.SoThe = b.SoThe;

--Đưa ra những độc giả chưa mượn sách lần nào từ 1/1/2021
select Sothe, HoTen, DiaChi, DienThoai
from DOC_GIA 
except
select a.Sothe, a.HoTen, a.DiaChi, a.DienThoai
from DOC_GIA a inner join MUON_SACH b on a.Sothe = b.SoThe
where NgayMuon >='2021-01-01'

--Đưa ra những độc giả có nhiều lần mượn sách nhất

select a.SoThe,a.HoTen, count(*) as 'Số lần mượn'
from DOC_GIA a inner join MUON_SACH b on a.Sothe = b.SoThe
group by a.Sothe, a.HoTen
having count(*) >= all( select count(*) as 'Số lần mượn'
from DOC_GIA a inner join MUON_SACH b on a.Sothe = b.SoThe
group by a.Sothe, a.HoTen)

--Đưa ra những thông tin của những độc giả mượn sách trong 10/2021
select a.Sothe, a.HoTen, a.DiaChi, a.DienThoai
from DOC_GIA a inner join MUON_SACH b on a.Sothe = b.SoThe
where NgayMuon>='2021-10-1' and NgayMuon <='2021-10-31'

--Thống kê số lần mượn sách của mỗi độc giả
select a.Sothe, a.HoTen, count(*) as 'Số lần mượn'
from DOC_GIA a inner join MUON_SACH b on a.Sothe = b.SoThe
group by a.Sothe, a.HoTen

--Liệt kê những tên sách có số lần mượn nhiều nhất
select a.TenSach, count(*) as 'Số lần mượn'
from SACH a inner join MUON_SACH b on a.MaSach = b.MaSach
group by a.TenSach
having count(*) >= all(select count(*)
from SACH a inner join MUON_SACH b on a.MaSach = b.MaSach
group by a.TenSach)

--Đưa ra tên độc giả mượn sách vào 10/2021 và kết thúc thuê vào 11/2021
select a.HoTen
from DOC_GIA a inner join MUON_SACH b on a.Sothe = b.SoThe
where b.NgayMuon >='2021-10-01' and b.NgayMuon<'2021-11-1' and b.NgayTra>='2021-11-1' and b.NgayTra<'2021-12-1'

--Đưa ra số lần mượn sách của mỗi ngày
select b.NgayMuon, count(*) as 'Số lần mượn'
from DOC_GIA a inner join MUON_SACH b on a.Sothe = b.SoThe
group by b.NgayMuon

--Đưa ra tên của các độc giả đã mượn sách vào ngày 1/2/2020 và trả vào ngày 20/3/2021
select a.HoTen
from DOC_GIA a inner join MUON_SACH b on a.Sothe = b.SoThe
where b.NgayMuon ='2020-02-01' and b.NgayTra='2020-03-20'

--đưa ra tên những độc giả chưa trả sách tính đến ngày 3/5/2021
select a.HoTen
from DOC_GIA a inner join MUON_SACH b on a.Sothe = b.SoThe
where b.NgayMuon <'2021-05-03' and b.NgayTra>='2021-05-03'

create table KHACH(
MaKhach varchar(10) not null primary key,
TenKhach nvarchar(30),
SoDienThoai varchar(10))

create table NHA(
MaNha varchar(10),
GiaThue int,
SoHopDong varchar(10)
primary key(MaNha,SoHopDong))


create table HopDong(
SoHopDong varchar(10),
MaKhach varchar(10) foreign key (MaKhach) references KHACH(MaKhach),
MaNha varchar(10),
foreign key (MaNha,SoHopDong) references NHA(MaNha,SoHopDong),
NgayBatDau date,
NgayKetThuc date)

insert into KHACH
values('K1',N'Lê Văn A','0123456789'),
('K2',N'Lê Văn B','0123456987'),
('K3',N'Nguyễn Văn C','0321456789')

insert into NHA
values('N1',300,'HD1'),
('N2',400,'HD2'),
('N3',500,'HD3')

insert into HopDong
values ('HD1','K1','N1','2021-05-15','2021-10-19'),
('HD2','K2','N2','2021-01-01','2021-12-19'),
('HD2','K1','N2','2021-10-19','2022-02-09')

--Đưa ra thông tin khách hàng đã thuê nhà
select distinct(a.MaKhach),a.TenKhach, a.SoDienThoai
from KHACH a inner join HopDong b on a.MaKhach = b.MaKhach

--Đưa ra những khách hàng chưa thuê nhà lần nào từ 10/2021
select a.MaKhach,a.TenKhach,a.SoDienThoai
from KHACH a
except
select a.MaKhach,a.TenKhach,a.SoDienThoai
from KHACH a inner join HopDong b on a.MaKhach = b.MaKhach
where NgayBatDau>='2021-10-1'
group by a.MaKhach,a.SoDienThoai,a.TenKhach
--hoặc
select *
from KHACH
where MaKhach not in (
    select a.MaKhach
    from KHACH a INNER JOIN HopDong b ON a.MaKhach = b.MaKhach
    WHERE NgayBatDau >= '2021-10-01'
    GROUP BY a.MaKhach
);

--Đưa ra những khách hàng có số lần thuê nhà nhiều nhất
select a.MaKhach, a.TenKhach, count(*) 'Số lần thuê nhà'
from KHACH a inner join HopDong b on a.MaKhach = b.MaKhach
group by a.MaKhach, a.TenKhach
having count(*) >= all(select count(*) 'Số lần thuê nhà'
from KHACH a inner join HopDong b on a.MaKhach = b.MaKhach
group by a.MaKhach, a.TenKhach)

--Đưa ra thông tin của những khách hàng đã thuê nhà từ trong tháng 5/2021 và trả vào tháng 10/2021
select a.MaKhach, a.TenKhach, a.SoDienThoai
from KHACH a inner join HopDong b on a.MaKhach = b.MaKhach
where NgayBatDau>='2021-05-01' and NgayBatDau<'2021-06-01' and NgayKetThuc>='2021-10-1' and NgayKetThuc<'2021-11-1'

--Thống kê số lần thuê nhà của mỗi khách hàng
select a.MaKhach, a.TenKhach , count(*) as 'Số lần thuê'
from KHACH a inner join HopDong b on a.MaKhach = b.MaKhach
group by a.MaKhach, a.TenKhach

--Đưa ra tên những căn nhà chưa được trả tính đến ngày 3/5/2021
select a.MaNha, a.GiaThue, a.SoHopDong
from NHA a inner join HopDong b on a.MaNha = b.MaNha
where NgayBatDau<'2021-05-03' and NgayKetThuc>'2021-05-03'

--Đưa ra căn hộ được thuê nhà nhiều nhất
select a.MaNha, count(*) 'Số lần thuê nhà'
from NHA a inner join HopDong b on a.MaNha = b.MaNha
group by a.MaNha
having count(*)>=all(select count(*) 'Số lần thuê nhà'
from NHA a inner join HopDong b on a.MaNha = b.MaNha
group by a.MaNha)

--Đưa ra tên khách bắt đầu thuê vào năm 2021 và kết thúc thuê vào 2022
select TenKhach
from KHACH a
INNER JOIN HopDong b ON a.MaKhach = b.MaKhach
where YEAR(NgayBatDau) = 2021 AND YEAR(NgayKetThuc) = 2022;

--Thống kê số lần thuê nhà của mỗi khách hàng
select TenKhach, count (*) as 'Số lần thuê nhà'
from KHACH a inner join HopDong b on a.MaKhach = b.MaKhach
group by TenKhach

--Đưa ra thôn tin những căn hộ đã cho thuê nhà trong tháng 10/2021
select a.MaNha, a.GiaThue, a.SoHopDong
from NHA a inner join HopDong b on a.MaNha = b.MaNha
where YEAR(NgayBatDau)='2021' and month(NgayBatDau)='10'

--Đưa ra thông tin những căn hộ có số lần thuê nhà từ 2 lần trở lên
select a.MaNha, a.GiaThue, a.SoHopDong, count(*) as 'Số lần thuê nhà'
from NHA a inner join HopDong b on a.MaNha = b.MaNha
group by a.MaNha, a.GiaThue, a.SoHopDong
having count(*)>=2

--Đưa ra căn hộ có số tiền thuê nhà cao nhất
select *
from NHA
where GiaThue >= all(select GiaThue from NHA)

create table SINHVIEN(
MaSinhVien varchar(10) not null primary key,
HoTen nvarchar(30),
NamSinh int,
QueQuan nvarchar(50),
HocLuc nvarchar(10))

create table DETAI(
MaDeTai varchar(10) not null primary key,
TenDeTai nvarchar(30),
ChuNhiemDeTai nvarchar(30),
KinhPhi int)

create table SV_DT(
MaSinhVien varchar(10) foreign key (MaSinhVien) references SINHVIEN(MaSinhVien),
MaDeTai varchar(10) foreign key (MaDeTai) references DETAI(MaDeTai),
NoiThucTap nvarchar(30),
KhoangCach int,
KetQua nvarchar(10))

insert into SINHVIEN
values('SV1',N'Lê Văn A',2004,N'Thanh Hóa',N'Xuất sắc'),
('SV2',N'Lê Văn B',2003,N'Hà Nội',N'Giỏi')
insert into SINHVIEN
values('SV3',N'Lê Văn C',2004,N'Bắc Giang',N'Giỏi')

insert into DETAI
values('DT1',N'Đề tài CNTT',N'TS.Nguyễn Văn A',1000),
('DT2',N'Đề tài KTPM',N'PGS.TS.Nguyễn Văn B',2000)

insert into DETAI
values('DT3',N'Đề tài ANM',N'TS.Nguyễn Văn C',1000)

insert into SV_DT
values ('SV1','DT1',N'Hà Nội',101,N'Đạt'),
('SV2','DT2',N'Hà Nội',30,N'Đạt')

--Đưa ra những địa điểm thực tập xa trường >100km
select NoiThucTap, KhoangCach
from SV_DT
where KhoangCach>100

--Thống kê số sinh viên thực hiện theo từng đề tài

select a.MaDeTai, a.TenDeTai, count(*) as 'Số sinh viên'
from DETAI a inner join SV_DT b on a.MaDeTai = b.MaDeTai
group by a.MaDeTai, a.TenDeTai

--Đưa ra những đề tài không có sinh viên nào tham gia
select MaDeTai,TenDeTai
from DETAI
except
select a.MaDeTai,a.TenDeTai
from DETAI a inner join SV_DT b on a.MaDeTai = b.MaDeTai

--hoặc

select MaDeTai,TenDeTai
from DETAI
where MaDeTai not in(select a.MaDeTai from DETAI a inner join SV_DT b on a.MaDeTai = b.MaDeTai)

