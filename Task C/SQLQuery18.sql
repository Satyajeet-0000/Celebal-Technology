--level task c 
--task 18

use level_task_C;

SELECT 
    BU.BusinessUnitID,
    CONVERT(VARCHAR(7), WC.MonthDate, 120) AS Month,
    SUM(WC.MonthlyCost * W.Salary) / SUM(W.Salary) AS WeightedAverageCost
FROM 
    Worker W
JOIN 
    WorkerCosts WC ON W.EmployeeID = WC.EmployeeID
JOIN 
    BusinessUnit BU ON W.BusinessUnitID = BU.BusinessUnitID
GROUP BY 
    BU.BusinessUnitID, CONVERT(VARCHAR(7), WC.MonthDate, 120)
ORDER BY 
    BU.BusinessUnitID, Month;