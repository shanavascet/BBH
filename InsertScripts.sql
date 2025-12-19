SET DEFINE OFF;

-- Insert Configuration 1: SENDER_AUTH - ADD with PROCESS_TYPE override
INSERT INTO APPROVAL_WORKFLOW_CONFIG (
    CONFIG_ID, 
    FUNCTION_CODE, 
    TASK_CODE, 
    APPROVAL_TYPE, 
    CONFIG_JSON, 
    IS_ACTIVE, 
    CREATED_BY, 
    CREATED_ON
)
VALUES (
    'APPR_CFG_002',
    'SENDER_AUTH',
    'ADD',
    'FIELD_BASED',
    '{
        "config_id": "APPR_CFG_002",
        "function_code": "SENDER_AUTH",
        "task_code": "ADD",
        "base_approvers": [
            {
                "seq": 1,
                "group_id": "FUND_TRNF",
                "group_name": "Funds Transfer"
            }
        ],
        "field_overrides": [
            {
                "field": "PROCESS_TYPE",
                "value": "ACH_DEBIT_BLOCKING",
                "approvers": [
                    {"seq": 1, "group_id": "FUND_TRNF", "group_name": "Funds Transfer"},
                    {"seq": 2, "group_id": "DEPT_HD", "group_name": "Department Head"}
                ]
            }
        ]
    }',
    'Y',
    'SYSTEM',
    SYSTIMESTAMP
);

-- Insert Configuration 2: SENDER_AUTH - MODIFY with AMOUNT range conditions
INSERT INTO APPROVAL_WORKFLOW_CONFIG (
    CONFIG_ID, 
    FUNCTION_CODE, 
    TASK_CODE, 
    APPROVAL_TYPE, 
    CONFIG_JSON, 
    IS_ACTIVE, 
    CREATED_BY, 
    CREATED_ON
)
VALUES (
    'APPR_CFG_003',
    'SENDER_AUTH',
    'MODIFY',
    'FIELD_BASED',
    '{
        "config_id": "APPR_CFG_003",
        "function_code": "SENDER_AUTH",
        "task_code": "MODIFY",
        "base_approvers": [
            {
                "seq": 1,
                "group_id": "FUND_TRNF",
                "group_name": "Funds Transfer"
            }
        ],
        "field_overrides": [
            {
                "field": "AMOUNT",
                "conditions": [
                    {
                        "range": {"min": 0, "max": 50000},
                        "approvers": [
                            {"seq": 1, "group_id": "FUND_TRNF", "group_name": "Funds Transfer"}
                        ]
                    },
                    {
                        "range": {"min": 50000},
                        "approvers": [
                            {"seq": 1, "group_id": "FUND_TRNF", "group_name": "Funds Transfer"},
                            {"seq": 2, "group_id": "DEPT_HD", "group_name": "Department Head"}
                        ]
                    }
                ]
            }
        ]
    }',
    'Y',
    'SYSTEM',
    SYSTIMESTAMP
);

-- Insert Configuration 3: BENEFICIARY_MAINT - ADD with COUNTRY override
INSERT INTO APPROVAL_WORKFLOW_CONFIG (
    CONFIG_ID, 
    FUNCTION_CODE, 
    TASK_CODE, 
    APPROVAL_TYPE, 
    CONFIG_JSON, 
    IS_ACTIVE, 
    CREATED_BY, 
    CREATED_ON
)
VALUES (
    'APPR_CFG_004',
    'BENEFICIARY_MAINT',
    'ADD',
    'FIELD_BASED',
    '{
        "config_id": "APPR_CFG_004",
        "function_code": "BENEFICIARY_MAINT",
        "task_code": "ADD",
        "base_approvers": [
            {
                "seq": 1,
                "group_id": "OPS_TEAM",
                "group_name": "Operations Team"
            }
        ],
        "field_overrides": [
            {
                "field": "COUNTRY",
                "value": "INTERNATIONAL",
                "approvers": [
                    {"seq": 1, "group_id": "OPS_TEAM", "group_name": "Operations Team"},
                    {"seq": 2, "group_id": "COMPLIANCE", "group_name": "Compliance"}
                ]
            }
        ]
    }',
    'Y',
    'SYSTEM',
    SYSTIMESTAMP
);

-- Insert Configuration 4: LIMIT_MGMT - UPDATE with LIMIT_AMOUNT range conditions
INSERT INTO APPROVAL_WORKFLOW_CONFIG (
    CONFIG_ID, 
    FUNCTION_CODE, 
    TASK_CODE, 
    APPROVAL_TYPE, 
    CONFIG_JSON, 
    IS_ACTIVE, 
    CREATED_BY, 
    CREATED_ON
)
VALUES (
    'APPR_CFG_005',
    'LIMIT_MGMT',
    'UPDATE',
    'FIELD_BASED',
    '{
        "config_id": "APPR_CFG_005",
        "function_code": "LIMIT_MGMT",
        "task_code": "UPDATE",
        "base_approvers": [
            {
                "seq": 1,
                "group_id": "REL_MNGR",
                "group_name": "Relationship Manager"
            }
        ],
        "field_overrides": [
            {
                "field": "LIMIT_AMOUNT",
                "conditions": [
                    {
                        "range": {"min": 0, "max": 100000},
                        "approvers": [
                            {"seq": 1, "group_id": "REL_MNGR", "group_name": "Relationship Manager"}
                        ]
                    },
                    {
                        "range": {"min": 100000},
                        "approvers": [
                            {"seq": 1, "group_id": "REL_MNGR", "group_name": "Relationship Manager"},
                            {"seq": 2, "group_id": "RISK_TEAM", "group_name": "Risk Team"},
                            {"seq": 3, "group_id": "COMPLIANCE", "group_name": "Compliance"}
                        ]
                    }
                ]
            }
        ]
    }',
    'Y',
    'SYSTEM',
    SYSTIMESTAMP
);

COMMIT;

SET DEFINE ON;
