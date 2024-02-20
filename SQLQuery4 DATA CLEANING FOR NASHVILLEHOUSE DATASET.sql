
SELECT TOP (1000) [UniqueID ]
      ,[ParcelID]
      ,[LandUse]
      ,[PropertyAddress]
      ,[SaleDate]
      ,[SalePrice]
      ,[LegalReference]
      ,[SoldAsVacant]
      ,[OwnerName]
      ,[OwnerAddress]
      ,[Acreage]
      ,[TaxDistrict]
      ,[LandValue]
      ,[BuildingValue]
      ,[TotalValue]
      ,[YearBuilt]
      ,[Bedrooms]
      ,[FullBath]
      ,[HalfBath]
  FROM [portfolio project].[dbo].[nashvillehousing]

  select *
  from [portfolio project].dbo.[nashvillehousing]

  --standardise date format
  select saledateconverted, convert(Date, SaleDate)
  from [portfolio project].dbo.nashvillehousing

  update nashvillehousing
  set SaleDate = convert(Date, SaleDate)

  alter table nashvillehousing
  add saledateconverted Date;

  update nashvillehousing
  set saledateconverted = convert(Date, SaleDate)

  --populate property address data

  select *
  from [portfolio project].dbo.[nashvillehousing]
--where PropertyAddress is null
order by ParcelID

   select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL (a.PropertyAddress, b.PropertyAddress)
  from [portfolio project].dbo.[nashvillehousing] a
  join [portfolio project].dbo.[nashvillehousing] b
  on a.ParcelID =b.ParcelID
  and a.[UniqueID] <>	b.[UniqueID]
where a.PropertyAddress is null

update a
set PropertyAddress = ISNULL (a.PropertyAddress, b.PropertyAddress)
 from [portfolio project].dbo.[nashvillehousing] a
  join [portfolio project].dbo.[nashvillehousing] b
  on a.ParcelID =b.ParcelID
  and a.[UniqueID] <>	b.[UniqueID]
  where a.PropertyAddress is null

  --breaking out address into individual columns(address,city,state)

  select PropertyAddress
  from [portfolio project].dbo.[nashvillehousing]
--where PropertyAddress is null
order by ParcelID

select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, len(PropertyAddress)) as address
from [portfolio project].dbo.[nashvillehousing]

 alter table nashvillehousing
  add Propertysplitaddress nvarchar (255);

update nashvillehousing
set Propertysplitaddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

   alter table nashvillehousing
  add Propertysplitcity nvarchar (255);

  update nashvillehousing
  set Propertysplitcity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, len(PropertyAddress)) 

  select PropertyAddress
  from [portfolio project].dbo.[nashvillehousing]


  select
parsename(REPLACE(OwnerAddress, ',', '.') , 3)
,parsename(replace(OwnerAddress, ',', '.') , 2)
,parsename(replace(OwnerAddress, ',', '.') , 1)
	from [portfolio project].dbo.[nashvillehousing]

	alter table nashvillehousing
  add ownersplitaddress nvarchar (255);

update nashvillehousing
set ownersplitaddress = parsename(REPLACE(OwnerAddress, ',', '.') , 3)

   alter table nashvillehousing
  add ownersplitcity nvarchar (255);

  update nashvillehousing
  set  ownersplitcity = parsename(replace(OwnerAddress, ',', '.') , 2)

   alter table nashvillehousing
  add ownersplitstate nvarchar (255);

  update nashvillehousing
  set  ownersplitstate = parsename(replace(OwnerAddress, ',', '.') , 1)




  select *
  from [portfolio project].dbo.[nashvillehousing]

  --change Y and N to yes and no on 'Sold as Vacant' field

  select(SoldAsVacant), count(SoldAsVacant)
   from [portfolio project].dbo.[nashvillehousing]
  group by SoldAsVacant
  order by 2

  select SoldAsVacant
,case when SoldAsVacant = 'Y' then 'Yes'
  when SoldAsVacant = 'N' then 'No'
  else SoldAsVacant
  end
  from [portfolio project].dbo.[nashvillehousing]

  update Nashvillehousing
  set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
  when SoldAsVacant = 'N' then 'No'
  else SoldAsVacant
  end

  --remove duplicates

  with RowNumCTE as(
  select *,
Row_number()  over (
  partition by ParcelID,
  PropertyAddress,
  SalePrice,
  SaleDate,
 LegalReference
 order by
 UniqueID
 ) row_num

  
 from [portfolio project].dbo.[nashvillehousing]

--order by ParcelID
)
 SELECT *
 from RowNumCTE 
 where Row_Num > 1






