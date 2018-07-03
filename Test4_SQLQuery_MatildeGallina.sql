use ProjectManagement

-- NomeDipendente (concatenazione di Nome + Cognome)
-- Sesso (con la lettera 'M' o 'F')

select [Name] + ' ' + [Surname] as NameSurname, (case when IsMale = 1 then 'M' else 'F' end) as Gender 
from Employees


-- Dipartimento (Name del dipartimento)
-- Progetti (count dei progetti. NON si può usare un semplice count, come da mail di ieri!)

select d.Name, sum(case when TotalProjectsPerEmployee is not null then TotalProjectsPerEmployee else 0 end) as TotalProj
from 
    (select e.Id as EmployeeId, count(*) as TotalProjectsPerEmployee
    from Projects as p
    left join Employees as e on e.Id = p.ManagerId
    group by e.Id) projPerEmployee
right join Employees as e on e.Id = projPerEmployee.EmployeeId
left join Departments as d on d.Id = e.DepartmentId
group by d.Name


-- Elenco di progetti non ancora chiusi.
-- Id (Id del progetto)
-- Dipartimento (Name del dipartimento del progetto, che sarebbe il nome del dipartimento del
-- manager!)
-- Nome (Name del progetto)
-- Manager (Nome del manager)

select p.Id as Id, d.Name as DepartmentName, p.Name as ProjName, e.Name as Manager
from Projects as p
left join Employees as e on e.Id = p.ManagerId
left join Departments as d on d.Id = e.DepartmentId
where p.EndDate is null
group by p.Id, d.Name, p.Name, e.Name


-- - Impiegato maschio che ha lavorato più ore a giugno, e quante ore ha fatto
-- - Impiegato femmina che ha lavorato meno ore a giugno, e quante ore ha fatto
-- (sono 2 query separate!)

select e.Name, t.MaxHours
from (select MAX(h.Quantity) as MaxHours
                from Hours as h, Employees as e
                where e.Id = h.EmployeeId and e.IsMale = 1) t
left join Hours as h on h.Quantity = t.MaxHours
left join Employees as e on e.Id = h.EmployeeId
group by e.Name, t.MaxHours
