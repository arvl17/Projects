Select * from PortfolioProjects..NashvilleHousing

-- Standardizing date format

Select SaleDateConverted, CONVERT(Date,SaleDate)
from PortfolioProjects..NashvilleHousing

Update NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)

Alter Table NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing 
Set SaleDateConverted = Convert(Date,SaleDate)

-- Populate Property Address Data

Select * from NashvilleHousing
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress) as aPropertyAddress
from PortfolioProjects..NashvilleHousing a
join PortfolioProjects..NashvilleHousing b
    on a.ParcelID = b.ParcelID
	and a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is NULL

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProjects..NashvilleHousing a
join PortfolioProjects..NashvilleHousing b
    on a.ParcelID = b.ParcelID
	and a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is NULL

-- Breaking out address into individual columns

Select propertyaddress 
from PortfolioProjects..NashvilleHousing


Select SUBSTRING(Propertyaddress, 1 , CHARINDEX(',', PropertyAddress) -1) as Address,
SUBSTRING(Propertyaddress, CHARINDEX(',', PropertyAddress), +  LEN(PropertyAddress)) as Address
from PortfolioProjects..NashvilleHousing


Alter Table NashvilleHousing
Add SplitAddres NvarChar(255);

Update NashvilleHousing 
Set SplitAddres = SUBSTRING(Propertyaddress, 1 , CHARINDEX(',', PropertyAddress) -1)

Alter Table NashvilleHousing
Add SplitCity NvarChar(255);

Update NashvilleHousing 
Set SplitCity = SUBSTRING(Propertyaddress, CHARINDEX(',', PropertyAddress), +  LEN(PropertyAddress))

Select PARSENAME(REPLACE(OwnerAddress, ',','.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',','.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',','.'), 1)
from PortfolioProjects..NashvilleHousing

Alter Table NashvilleHousing
Add OSplitAddress NvarChar(255);

Update NashvilleHousing 
Set OSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',','.'), 3)

Alter Table NashvilleHousing
Add OSplitCity NvarChar(255);

Update NashvilleHousing 
Set OSplitCity = PARSENAME(REPLACE(OwnerAddress, ',','.'), 2)

Alter Table NashvilleHousing
Add OSplitState NvarChar(255);

Update NashvilleHousing 
Set OSplitState = PARSENAME(REPLACE(OwnerAddress, ',','.'), 1)


-- Replacing Y and N to Yes and No in "Sold as Vacant"

Select Distinct(SoldAsVacant)
From PortfolioProjects..NashvilleHousing

Select SoldAsVacant,
Case When SoldAsVacant = 'Y' then 'Yes'
	 When SoldAsVacant = 'N' then 'No'
	 Else SoldAsVacant
End as SoldAsVacants
from PortfolioProjects..NashvilleHousing

Update NashvilleHousing
SET SoldAsVacant = Case When SoldAsVacant = 'Y' then 'Yes'
	 When SoldAsVacant = 'N' then 'No'
	 Else SoldAsVacant
End 


-- Removing Duplicates

With RowNumCTE as(
Select *,
ROW_NUMBER() Over(
Partition by ParcelID,
             PropertyAddress,
			 SalePrice,
			 SaleDate,
			 LegalReference
			 Order by 
			 UniqueID
			 ) row_num
from PortfolioProjects..NashvilleHousing
)

Select * from RowNumCTE
where row_num > 1
order by PropertyAddress




-- Deleting unused columns


Alter table PortfolioProjects..NashvilleHousing
drop column owneraddress, taxdistrict, propertyaddress, SaleDate


