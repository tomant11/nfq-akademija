#
# Pavyzdþiai
#

#
# SELECT, CONCAT
#


SELECT
	`Persons`.*,
	`Contacts`.*,
	`Companies`.*,
	`Cities`.`name` AS `city`,
	CONCAT(`Persons`.`firstName`,' ', `Persons`.`lastName`) AS `fullName`,
FROM `Persons`
	LEFT JOIN `Contacts` ON `Contacts`.`contactId` = `Persons`.`contactId`
	LEFT JOIN `Companies` ON `Companies`.`companyId` = `Persons`.`companyId`
	LEFT JOIN `CompanyTypes` ON `Companies`.`typeId` = `CompanyTypes`.`typeId`
	LEFT JOIN `Cities` ON `Cities`.`cityId` = `Contacts`.`cityId`
WHERE `Persons`.`companyId` = :companyId


#
# JOINS, subselects
#

SELECT SQL_CALC_FOUND_ROWS DISTINCT
     `Companies`.*
	, `Relations`.`date` AS `becameClient`
	, CONCAT_WS(', ', `Companies`.`name`, `CompanyTypes`.`abbreviation`) AS `fullName`
	, CONCAT(`Persons`.`firstName`, ' ', `Persons`.`lastName`) AS `responsibleUser`
	, `CompanyDepartments`.`name` AS `responsibleDepartment`
FROM `Companies`
	LEFT JOIN `CompanyTypes`
		ON `Companies`.`typeId` = `CompanyTypes`.`typeId`
	LEFT JOIN `Users`
		ON (`Companies`.`responsibleUserId` = `Users`.`userId`)
	LEFT JOIN `Persons`
		ON (`Users`.`personId` = `Persons`.`personId`)
	LEFT JOIN `CompanyDepartments`
		ON (`Companies`.`responsibleDepartmentId` = `CompanyDepartments`.`departmentId`)
	LEFT JOIN
			(SELECT MIN(`publishDate`) AS `date`
				, `companyId`
			FROM `Companies_Relations`
			WHERE `typeId` = 1
			GROUP BY `companyId`) AS `Relations`
		ON (`Companies`.`companyId` = `Relations`.`companyId`)
WHERE `Companies`.`isClient` = 1 AND `Relations`.`date` IS NOT NULL


UPDATE `oxarticles`
INNER JOIN (
    SELECT MIN(oxprice) as `minprice`, max(oxprice) as `maxprice`, `oxparentid`
    FROM `oxarticles`
    WHERE oxparentId IS NOT NULL AND oxparentid != ''
    GROUP BY oxparentid ) AS `arts`  ON  `oxarticles`.`oxid` = `arts`.`oxparentid`
SET `oxarticles`.`oxvarminprice` = `arts`.`minprice`, `oxarticles`.`oxvarmaxprice` = `arts`.`maxprice`;


#
# JOINS GROUP_CONCAT
#

SELECT
	  `Services`.`serviceId`
	, `Services`.`name`
	, `Services`.`shortName`
	, GROUP_CONCAT(`Pests`.`name` SEPARATOR ', ') AS `pests`
FROM `Services`
LEFT JOIN `Service_Pest`
	ON (`Service_Pest`.`serviceId` = `Services`.`serviceId`)
LEFT JOIN `Pests`
	ON (`Pests`.`pestId` = `Service_Pest`.`pestId`)
WHERE `Services`.`serviceId` = :serviceId

GROUP BY `Services`.`serviceId`

#
# UNION
#

SELECT `RT`.`cnt`
FROM (
	SELECT COUNT(`groupId`) AS `cnt` FROM `TaskViewersGroups`
	WHERE `groupId` = :groupId
	UNION
	SELECT COUNT(`groupId`) AS `cnt` FROM `UsersGroups_Users`
	WHERE `groupId` = :groupId
	UNION
	SELECT COUNT(`groupId`) AS `cnt` FROM `ScheduledTaskViewersGroups`
	WHERE `groupId` = :groupId
	UNION
	SELECT COUNT(`groupId`) AS `cnt` FROM `ScheduledTaskExecutorsGroups`
	WHERE `groupId` = :groupId
) AS `RT`

#
# COUNT
#

SELECT `Announcements`.*
	, `AnnouncementTypes`.`name` AS `type`
	, CONCAT(`Persons`.`firstName`, ' ', `Persons`.`lastName`) AS `publisher`
	, COUNT(`AnnouncementFiles`.`fileId`) AS `filesCount`
FROM `Announcements`
	INNER JOIN `AnnouncementTypes`
		ON (`Announcements`.`typeId` = `AnnouncementTypes`.`typeId`)
	LEFT JOIN `Users`
		ON (`Users`.`userId` = `Announcements`.`publisherId`)
	LEFT JOIN `Persons`
		ON (`Users`.`personId` = `Persons`.`personId`)
	LEFT JOIN `AnnouncementFiles`
		ON (`AnnouncementFiles`.`announcementId` = `Announcements`.`announcementId`)
WHERE `Announcements`.`isImportant` = 1
GROUP BY `Announcements`.`announcementId`
ORDER BY `AnnouncementTypes`.`name`, `publishDate` DESC


#
# SQL_CALC_FOUND_ROWS + SELECT FOUND_ROWS() vs COUNT(*)
#

SELECT SQL_CALC_FOUND_ROWS
	`table`.*
FROM `table` LIMIT 10;

SELECT FOUND_ROWS();

# VS


SELECT 
	`table`.*
FROM `table` LIMIT 10;

SELECT
	COUNT(`table`.*)
FROM `table`;





#
# Kuo skiriasi ðios uþklausos?
#

SELECT COUNT( companyId )
FROM Companies
	LEFT JOIN Cities ON Cities.cityId = Companies.cityId
GROUP BY Companies.companyId;

# VS

SELECT COUNT( companyId )
FROM Cities
	LEFT JOIN Companies ON Cities.cityId = Companies.cityId
GROUP BY Companies.companyId;



