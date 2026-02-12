/* LOAD DATA IN SILVER */


INSERT INTO silver.crm_cust_info(
	cst_id,
    cst_key,
    cst_firstname,
    cst_lastname,
    cst_marital_status,
    cst_gndr,
    cst_create_date
)
SELECT

/* cst_id -> INT */
CASE WHEN cst_id REGEXP '^[0-9]+$' THEN CAST(cst_id AS UNSIGNED)
	ELSE NULL
END cst_id,

cst_key,

/* cleaned names */
TRIM(cst_firstname) AS cst_firstname,
TRIM(cst_lastname) AS cst_lastname,

/* Normalizing marital status and gender */
CASE WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
	WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
    ELSE 'n/a'
END cst_marital_status,
CASE WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
	WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
    ELSE 'n/a'
END cst_gndr,

/* cst_create_date -> date */
CASE WHEN cst_create_date IS NULL THEN NULL
	ELSE CAST(cst_create_date AS DATE)
END AS cst_create_date
FROM (
	SELECT 
	*,
	ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) flag_last
	FROM bronze.crm_cust_info
    WHERE cst_id IS NOT NULL
) t
WHERE flag_last = 1 AND cst_id REGEXP '^[0-9]+$';


INSERT INTO silver.crm_prd_info(
	prd_id,
    cat_id,
    prd_key,
    prd_nm,
    prd_cost,
    prd_line,
    prd_start_dt,
    prd_end_dt
)
SELECT
CASE WHEN prd_id REGEXP '^[0-9]+$' THEN CAST(prd_id AS UNSIGNED)
	ELSE NULL
END prd_id,
REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id, -- Extract category ID
SUBSTRING(prd_key, 7, LENGTH(prd_key)) AS prd_key, -- Extract product key
prd_nm,
CASE WHEN prd_cost REGEXP '^[0-9]+$' THEN CAST(prd_cost AS UNSIGNED)
	ELSE 0 
END prd_cost,
CASE WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
	WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
    WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
    WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
	ELSE 'n/a'
END AS prd_line, -- Map product line codes to descriptive values
CASE WHEN prd_start_dt IS NULL THEN NULL
	ELSE CAST(prd_start_dt AS DATE)
END AS prd_start_dt,
DATE_SUB(
	LEAD(CAST(prd_start_dt AS DATE)) 
	OVER (PARTITION BY prd_key ORDER BY CAST(prd_start_dt AS DATE)), INTERVAL 1 DAY
) AS prd_end_dt -- Calculate end date as one day before the next start date
FROM bronze.crm_prd_info;


INSERT INTO silver.crm_sales_details (
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    sls_order_dt,
    sls_ship_dt,
    sls_due_dt,
    sls_sales,
    sls_quantity,
    sls_price
)

WITH cleaned AS (
    SELECT
        sls_ord_num,
        sls_prd_key,

        CASE 
            WHEN sls_sales REGEXP '^-?[0-9]+$'
            THEN CAST(sls_sales AS SIGNED)
            ELSE NULL
        END AS sls_sales,

        CASE 
            WHEN sls_price REGEXP '^-?[0-9]+$'
            THEN CAST(sls_price AS SIGNED)
            ELSE NULL
        END AS sls_price,

        CASE 
            WHEN sls_quantity REGEXP '^-?[0-9]+$'
            THEN CAST(sls_quantity AS SIGNED)
            ELSE NULL
        END AS sls_quantity,

        sls_cust_id,
        sls_order_dt,
        sls_ship_dt,
        sls_due_dt

    FROM bronze.crm_sales_details
)

SELECT
    sls_ord_num,
    sls_prd_key,

    CASE 
        WHEN sls_cust_id REGEXP '^[0-9]+$'
        THEN CAST(sls_cust_id AS UNSIGNED)
        ELSE NULL
    END,

    CASE WHEN sls_order_dt REGEXP '^[0-9]{8}$'
         THEN STR_TO_DATE(sls_order_dt,'%Y%m%d')
         ELSE NULL END,

    CASE WHEN sls_ship_dt REGEXP '^[0-9]{8}$'
         THEN STR_TO_DATE(sls_ship_dt,'%Y%m%d')
         ELSE NULL END,

    CASE WHEN sls_due_dt REGEXP '^[0-9]{8}$'
         THEN STR_TO_DATE(sls_due_dt,'%Y%m%d')
         ELSE NULL END,

    CASE
        WHEN sls_sales IS NULL
             OR sls_sales <= 0
             OR sls_sales != ABS(sls_price) * sls_quantity
        THEN ABS(sls_price) * sls_quantity
        ELSE sls_sales
    END,

    ABS(COALESCE(sls_quantity,1)),

    CASE
        WHEN sls_price IS NULL OR sls_price <= 0
        THEN ABS(sls_sales) / NULLIF(ABS(sls_quantity),0)
        ELSE ABS(sls_price)
    END

FROM cleaned;

INSERT INTO silver.erp_cust_az12(
	cid,
    bdate,
    gen
)
SELECT
CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LENGTH(cid))
	ELSE cid
END cid,
CASE WHEN CAST(bdate AS DATE) > CURDATE() THEN NULL
	ELSE CAST(bdate AS DATE)
END bdate,
CASE WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
	WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
    ELSE 'n/a'
END gen
FROM bronze.erp_cust_az12;


INSERT INTO silver.erp_loc_a101(
	cid,
    cntry
)
SELECT
REPLACE(cid, '-', '') cid,
CASE WHEN TRIM(cntry) = 'DE' THEN 'Germany'
	WHEN TRIM(cntry) IN ('US', 'USA') THEN 'United States'
    WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
	ELSE TRIM(cntry)
END AS cntry
FROM bronze.erp_loc_a101;


INSERT INTO silver.erp_px_cat_g1v2(
	id,
    cat,
    subcat,
    maintenance
)
SELECT
id,
cat,
subcat,
maintenance
FROM erp_px_cat_g1v2;
