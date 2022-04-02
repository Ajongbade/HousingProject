-- cleaning nashville house data

select * from housingdata


-- standardize sale date 


select saledate, convert(date, saledate) from housingdata


alter table housingdata 
add saledateconverted date;

update housingdata 
set saledateconverted = convert(date, saledate)

select saledateconverted from housingdata


-- populate property address where values are null

select a.parcelID, a.propertyaddress, b.parcelID, b.propertyaddress, isnull(a.propertyaddress, b.propertyaddress) 
from housingdata a
join housingdata b on a.parcelID = b.parcelID
and a.uniqueID <> b.UniqueID
where a.propertyaddress is null

update a
set propertyaddress = isnull(a.propertyaddress, b.propertyaddress) 
from housingdata a
join housingdata b on a.parcelID = b.parcelID
and a.uniqueID <> b.UniqueID
where a.propertyaddress is null




--separating address into individual columns using SUBSTRING

select propertyaddress from housingdata

select substring(propertyaddress, 1, charindex (',', propertyaddress)- 1) as address,
substring(propertyaddress, charindex (',', propertyaddress)+ 1, len(propertyaddress)) as address from housingdata

alter table housingdata 
add propertystreet nvarchar (255);

update housingdata 
set propertystreet =  substring(propertyaddress, 1, charindex (',', propertyaddress)- 1) 

alter table housingdata 
add propertycity nvarchar(255);
update housingdata 
set propertycity = substring(propertyaddress, charindex (',', propertyaddress)+ 1, len(propertyaddress))


select * from housingdata


--separating owneraddress into individual columns using PARSENAME

select parsename (replace(owneraddress, ',', '.') , 3), 
parsename (replace(owneraddress, ',', '.') , 2),
parsename (replace(owneraddress, ',', '.') , 1) 

from housingdata


alter table housingdata 
add ownerstreet nvarchar (255);

update housingdata 
set ownerstreet =  parsename (replace(owneraddress, ',', '.') , 3)

alter table housingdata 
add ownercity nvarchar(255);
update housingdata 
set ownercity = parsename (replace(owneraddress, ',', '.') , 2)


alter table housingdata 
add ownerstate nvarchar(255);
update housingdata 
set ownerstate = parsename (replace(owneraddress, ',', '.') , 1)


