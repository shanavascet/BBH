Based on the screenshots showing approval user groups data, here's a comprehensive Oracle database script:

```sql
-- =====================================================
-- APPROVAL USER GROUPS DATABASE SCHEMA
-- =====================================================

-- Drop tables if they exist (for clean reinstall)
DROP TABLE approval_user_group_members CASCADE CONSTRAINTS;
DROP TABLE approval_user_groups CASCADE CONSTRAINTS;
DROP SEQUENCE seq_approval_group_id;

-- =====================================================
-- SEQUENCE FOR AUTO-INCREMENT ID
-- =====================================================
CREATE SEQUENCE seq_approval_group_id
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

-- =====================================================
-- MAIN TABLE: APPROVAL_USER_GROUPS
-- =====================================================
CREATE TABLE approval_user_groups (
    group_id            NUMBER(10)      PRIMARY KEY,
    group_code          VARCHAR2(50)    NOT NULL UNIQUE,
    group_name          VARCHAR2(200)   NOT NULL,
    status              VARCHAR2(20)    DEFAULT 'ACTIVE' CHECK (status IN ('ACTIVE', 'INACTIVE', 'PENDING', 'SUSPENDED')),
    effective_start_date DATE           DEFAULT SYSDATE,
    effective_end_date   DATE,
    created_on          TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    created_by          VARCHAR2(100)   NOT NULL,
    updated_on          TIMESTAMP       DEFAULT SYSTIMESTAMP,
    updated_by          VARCHAR2(100),
    description         VARCHAR2(500),
    is_deleted          CHAR(1)         DEFAULT 'N' CHECK (is_deleted IN ('Y', 'N')),
    
    -- Constraints
    CONSTRAINT chk_effective_dates CHECK (effective_end_date IS NULL OR effective_end_date >= effective_start_date)
);

-- =====================================================
-- CHILD TABLE: GROUP MEMBERS (Optional - for user assignments)
-- =====================================================
CREATE TABLE approval_user_group_members (
    member_id           NUMBER(10)      PRIMARY KEY,
    group_id            NUMBER(10)      NOT NULL,
    user_id             VARCHAR2(50)    NOT NULL,
    user_name           VARCHAR2(200),
    member_role         VARCHAR2(50)    DEFAULT 'MEMBER' CHECK (member_role IN ('ADMIN', 'APPROVER', 'MEMBER', 'VIEWER')),
    effective_start_date DATE           DEFAULT SYSDATE,
    effective_end_date   DATE,
    created_on          TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    created_by          VARCHAR2(100)   NOT NULL,
    is_active           CHAR(1)         DEFAULT 'Y' CHECK (is_active IN ('Y', 'N')),
    
    -- Foreign Key
    CONSTRAINT fk_group_member FOREIGN KEY (group_id) REFERENCES approval_user_groups(group_id) ON DELETE CASCADE,
    
    -- Unique constraint to prevent duplicate user assignments
    CONSTRAINT uk_group_user UNIQUE (group_id, user_id, effective_start_date)
);

-- =====================================================
-- INDEXES FOR PERFORMANCE
-- =====================================================
CREATE INDEX idx_group_code ON approval_user_groups(group_code);
CREATE INDEX idx_group_status ON approval_user_groups(status);
CREATE INDEX idx_group_created_on ON approval_user_groups(created_on);
CREATE INDEX idx_member_group_id ON approval_user_group_members(group_id);
CREATE INDEX idx_member_user_id ON approval_user_group_members(user_id);

-- =====================================================
-- TRIGGER: AUTO-INCREMENT GROUP_ID
-- =====================================================
CREATE OR REPLACE TRIGGER trg_approval_group_id
BEFORE INSERT ON approval_user_groups
FOR EACH ROW
WHEN (NEW.group_id IS NULL)
BEGIN
    :NEW.group_id := seq_approval_group_id.NEXTVAL;
END;
/

-- =====================================================
-- TRIGGER: AUTO-UPDATE TIMESTAMP
-- =====================================================
CREATE OR REPLACE TRIGGER trg_approval_group_update
BEFORE UPDATE ON approval_user_groups
FOR EACH ROW
BEGIN
    :NEW.updated_on := SYSTIMESTAMP;
END;
/

-- =====================================================
-- INSERT DATA FROM SCREENSHOTS
-- =====================================================

-- Batch 1 (From Image 1)
INSERT ALL
    INTO approval_user_groups (group_id, group_code, group_name, created_by) VALUES (1, 'FND_ACT_ST_CNFG', 'FUND ACCOUNTING STAR CONFIGURATION', 'SYSTEM')
    INTO approval_user_groups (group_id, group_code, group_name, created_by) VALUES (2, 'ACCT_MNGR', 'ACCOUNT MANAGER', 'SYSTEM')
    INTO approval_user_groups (group_id, group_code, group_name, created_by) VALUES (3, 'CA_OP', 'CREDIT ADMIN & OPERATIONS', 'SYSTEM')
    INTO approval_user_groups (group_id, group_code, group_name, created_by) VALUES (4, 'CAP', 'CLIENT ACCOUNT PROFILE', 'SYSTEM')
    INTO approval_user_groups (group_id, group_code, group_name, created_by) VALUES (5, 'CAPMGT', 'CLIENT ACCOUNT PROFILE MANAGEMENT', 'SYSTEM')
    INTO approval_user_groups (group_id, group_code, group_name, created_by) VALUES (6, 'CAT', 'CENTRAL ACCOUNT TEAM', 'SYSTEM')
    INTO approval_user_groups (group_id, group_code, group_name, created_by) VALUES (7, 'COMPLIANCE', 'COMPLIANCE APPROVER', 'SYSTEM')
    INTO approval_user_groups (group_id, group_code, group_name, created_by) VALUES (8, 'CORE_CNTR', 'CORE CONTROLLERS', 'SYSTEM')
    INTO approval_user_groups (group_id, group_code, group_name, created_by) VALUES (9, 'CORP_ACT', 'CORPORATE ACTIONS', 'SYSTEM')
    INTO approval_user_groups (group_id, group_code, group_name, created_by) VALUES (10, 'CORP_ACT_SOD', 'CORPORATE ACTIONS SOD', 'SYSTEM')
    INTO approval_user_groups (group_id, group_code, group_name, created_by) VALUES (11, 'CS_HUB', 'CLIENT SERVICE HUB', 'SYSTEM')
    INTO approval_user_groups (group_id, group_code, group_name, created_by) VALUES (12, 'DEPT_HD', 'DEPARTMENT HEAD', 'SYSTEM')
    INTO approval_user_groups (group_id, group_code, group_name, created_by) VALUES (13, 'DIER_CNTR', 'DIER II CONTROLLERS', 'SYSTEM')
    INTO approval_user_groups (group_id, group_code, group_name, created_by) VALUES (14, 'FX', 'FOREIGN EXCHANGE', 'SYSTEM')
    INTO approval_user_groups (group_id, group_code, group_name, created_by) VALUES (15, 'FX_REG', 'FOREIGN EXCHANGE REG REPORTING', 'SYSTEM')
    INTO approval_user_groups (group_id, group_code, group_name, created_by) VALUES (16, 'FXCLS', 'FX-CLS', 'SYSTEM')
    INTO approval_user_groups (group_id, group_code, group_name, created_by) VALUES (17, 'GTO', 'GLOBAL TAX OPERATIONS', 'SYSTEM')
    INTO approval_user_groups (group_id, group_code, group_name, created_by) VALUES (18, 'GTS', 'GLOBAL TAX SERVICE', 'SYSTEM')
    INTO approval_user_groups (group_id, group_code, group_name, created_by) VALUES (19, 'IM_CS', 'IM CLIENT SERVICE', 'SYSTEM')
    INTO approval_user_groups (group_id, group_code, group_name, created_by) VALUES (20, 'IM_RISK_MNGT', 'IM RISK MANAGEMENT', 'SYSTEM')
SELECT 1 FROM DUAL;

-- Batch 2 (From Image 2)
INSERT ALL
    INTO approval_user_groups (group_id, group_code, group_name, created_by) VALUES (21, 'IMS_MGMT', 'INVESTMENT MANAGEMENT SERVICE (ASMG)', 'SYSTEM')
    INTO approval_user_groups (group_id, group_code, group_name, created_by) VALUES (22, 'IRAA_RISK', 'IRAA RISK', 'SYSTEM')
    INTO approval_user_groups (group_id, group_code, group_name, created_by) VALUES (23, 'IS_BILLING', 'IS BILLING', 'SYSTEM')
    INTO approval_user_groups (group_id, group_code, group_name, created_by) VALUES (24, 'MUTUAL_FUNDS', 'MUTUAL FUNDS', 'SYSTEM')
    INTO approval_user_groups (group_id, group_code, group_name, created_by) VALUES (25, 'NETWORK', 'NETWORK', 'SYSTEM')
    INTO approval_user_groups (group_id, group_code, group_name, created_by) VALUES (26, 'PB_BILLING', 'PB BILLING', 'SYSTEM')
    INTO approval_user_groups (group_id, group_code, group_name, created_by) VALUES (27, 'REG', 'REGISTRATION APPROVER TEAM', 'SYSTEM')
    INTO approval_user_groups (group_id, group_code, group_name, created_by) VALUES (28, 'REG2', 'REGISTRATION APPROVER TEAM 2', 'SYSTEM')
    INTO approval_user_groups (group_id, group_code, group_name, created_by) VALUES (29, 'REGMGT', 'REGISTRATION TEAM MANAGEMENT', 'SYSTEM')
    INTO approval_user_groups (group_id, group_code, group_name, created_by) VALUES (30, 'RISK', 'RISK', 'SYSTEM')
    INTO approval_user_groups (group_id, group_code, group_name, created_by) VALUES (31, 'TECH', 'TECHNOLOGY PRODUCT MANAGEMENT', 'SYSTEM')
    INTO approval_user_groups (group_id, group_code, group_name, created_by) VALUES (32, 'TREASURY_BOS', 'TREASURY BOSTON', 'SYSTEM')
    INTO approval_user_groups (group_id, group_code, group_name, created_by) VALUES (33, 'TREASURY_NY', 'TREASURY NEW YORK', 'SYSTEM')
    INTO approval_user_groups (group_id, group_code, group_name, created_by) VALUES (34, 'AMR_REQUESTOR', 'AMR REQUESTOR', 'SYSTEM')
    INTO approval_user_groups (group_id, group_code, group_name, created_by) VALUES (35, 'FUND_TRNF_US', 'FUND TRANSFER US', 'SYSTEM')
    INTO approval_user_groups (group_id, group_code, group_name, created_by) VALUES (36, 'R_A', 'RECONCILIATION AND ANALYSIS', 'SYSTEM')
    INTO approval_user_groups (group_id, group_code, group_name, created_by) VALUES (37, 'FX_OPS', 'FOREIGN EXCHANGE OPS', 'SYSTEM')
    INTO approval_user_groups (group_id, group_code, group_name, created_by) VALUES (38, 'NNIP_CSG', 'NNIP CSG APPROVER', 'SYSTEM')
SELECT 1 FROM DUAL;

-- Batch 3 (From Image 3)
INSERT ALL
    INTO approval_user_groups (group_id, group_code, group_name, created_by) VALUES (39, 'FUND_TRNF', 'FUND TRANSFER', 'SYSTEM')
    INTO approval_user_groups (group_id, group_code, group_name, created_by) VALUES (40, 'FUND_TRNF2', 'FUND TRANSFER 2', 'SYSTEM')
    INTO approval_user_groups (group_id, group_code, group_name, created_by) VALUES (41, 'FUND_TRNF3', 'FUND TRANSFER 3', 'SYSTEM')
    INTO approval_user_groups (group_id, group_code, group_name, created_by) VALUES (42, 'FUND_TRNF4', 'FUND TRANSFER 4', 'SYSTEM')
    INTO approval_user_groups (group_id, group_code, group_name, created_by) VALUES (43, 'FX_DEPT', 'FX DEPARTMENT', 'SYSTEM')
    INTO approval_user_groups (group_id, group_code, group_name, created_by) VALUES (44, 'FT_SPEC_PROC', 'FT SPECIAL PROCESSING', 'SYSTEM')
    INTO approval_user_groups (group_id, group_code, group_name, created_by) VALUES (45, 'GTS1', 'GTS PASSIVE APPROVER 1', 'SYSTEM')
    INTO approval_user_groups (group_id, group_code, group_name, created_by) VALUES (46, 'CGT1', 'CGT PASSIVE APPROVER 1', 'SYSTEM')
    INTO approval_user_groups (group_id, group_code, group_name, created_by) VALUES (47, 'GTS2', 'GTS PASSIVE APPROVER 2', 'SYSTEM')
    INTO approval_user_groups (group_id, group_code, group_name, created_by) VALUES (48, 'SDCD', 'SERVICE DELIVERY COMPLIANCE DISCIPLINE', 'SYSTEM')
    INTO approval_user_groups (group_id, group_code, group_name, created_by) VALUES (49, 'AML_GFC', 'AML COMPLIANCE - GFC', 'SYSTEM')
    INTO approval_user_groups (group_id, group_code, group_name, created_by) VALUES (50, 'AMFX', 'FOREIGN EXCHANGE AMFX', 'SYSTEM')
    INTO approval_user_groups (group_id, group_code, group_name, created_by) VALUES (51, 'SSI_TEAM', 'STANDING SETTLEMENT INSTRUCTION TEAM', 'SYSTEM')
SELECT 1 FROM DUAL;

COMMIT;

-- =====================================================
-- USEFUL QUERIES
-- =====================================================

-- Query 1: View all active groups
-- SELECT * FROM approval_user_groups WHERE status = 'ACTIVE' ORDER BY group_id;

-- Query 2: Search by group code
-- SELECT * FROM approval_user_groups WHERE group_code LIKE '%FUND%';

-- Query 3: View groups with members count
-- SELECT g.group_id, g.group_code, g.group_name, COUNT(m.member_id) as member_count
-- FROM approval_user_groups g
-- LEFT JOIN approval_user_group_members m ON g.group_id = m.group_id
-- GROUP BY g.group_id, g.group_code, g.group_name
-- ORDER BY g.group_id;

-- =====================================================
-- GRANTS (Adjust as per your security requirements)
-- =====================================================
-- GRANT SELECT, INSERT, UPDATE, DELETE ON approval_user_groups TO your_app_user;
-- GRANT SELECT, INSERT, UPDATE, DELETE ON approval_user_group_members TO your_app_user;
-- GRANT SELECT ON seq_approval_group_id TO your_app_user;

-- =====================================================
-- COMMENTS
-- =====================================================
COMMENT ON TABLE approval_user_groups IS 'Stores approval user group definitions';
COMMENT ON COLUMN approval_user_groups.group_id IS 'Primary key - auto-generated';
COMMENT ON COLUMN approval_user_groups.group_code IS 'Unique group identifier code';
COMMENT ON COLUMN approval_user_groups.group_name IS 'Descriptive name of the group';
COMMENT ON COLUMN approval_user_groups.status IS 'Current status: ACTIVE, INACTIVE, PENDING, SUSPENDED';
COMMENT ON COLUMN approval_user_groups.effective_start_date IS 'Date when group becomes effective';
COMMENT ON COLUMN approval_user_groups.effective_end_date IS 'Date when group expires';

-- End of script
```

This script includes:

1. **Two main tables**: Main groups table and a members table for user assignments
2. **Auto-incrementing sequence** for group IDs
3. **Triggers** for automatic ID generation and update timestamps
4. **All 51 groups** from your screenshots
5. **Indexes** for performance optimization
6. **Constraints** for data integrity
7. **Audit columns** (created_by, created_on, updated_by, updated_on)
8. **Status management** with check constraints
9. **Soft delete capability** (is_deleted flag)
10. **Comments** for documentation

The script is ready to execute in Oracle SQL*Plus, SQL Developer, or any Oracle database tool.