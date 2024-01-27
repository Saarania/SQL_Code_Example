USE Epptech;


-- 1) & 2)

CREATE TABLE tblClients (
	PK_Clients INT IDENTITY(1,1) PRIMARY KEY,
	First_Name VARCHAR(25),
	Last_Name VARCHAR(25)
);

CREATE TABLE tblTransactionTypes (
	PK_TransactionsTypes INT IDENTITY(1,1) PRIMARY KEY,
	Name VARCHAR(25)
);

CREATE TABLE tblBalances (
	PK_Balances INT IDENTITY(1,1) PRIMARY KEY,
	Currency VARCHAR(10),
	Balance INT
);

-- 4)

CREATE TABLE tblDailySnapshot (
	PK_Clients INT IDENTITY(1,1) PRIMARY KEY,
	FK_Balance INT FOREIGN KEY REFERENCES tblBalances(PK_BALANCES),
	Valid_Period DATE,
	Loan int,
	Interest int,
	Fees int
);		


CREATE TABLE tblAccounts (
	PK_Accounts INT IDENTITY(1,1) PRIMARY KEY,
	FK_Client INT FOREIGN KEY REFERENCES tblClients(PK_Clients),
	FK_Balance INT FOREIGN KEY REFERENCES tblBalances(PK_Balances)
);

-- 3)

CREATE TABLE tblTransactions (
	PK_Transactions INT IDENTITY(1,1) PRIMARY KEY,
	FK_Account_Sender INT FOREIGN KEY REFERENCES tblAccounts(PK_Accounts),
	FK_Account_Recipient INT FOREIGN KEY REFERENCES tblAccounts(PK_Accounts),
	FK_Balance INT FOREIGN KEY REFERENCES tblBalances(PK_Balances),
	FK_TransactionType INT FOREIGN KEY REFERENCES tblTransactionTypes(PK_TransactionsTypes)
		
);


-- 5) c = 400

SELECT tblClients.Last_Name, tblClients.First_Name, SUM(tblDailySnapshot.Loan) FROM tblAccounts 
	INNER JOIN tblClients ON tblAccounts.FK_Client=tblClients.PK_Clients 
	INNER JOIN tblBalances ON tblAccounts.FK_Balance=tblBalances.PK_Balances
	INNER JOIN tblDailySnapshot ON tblBalances.PK_Balances=tblDailySnapshot.FK_Balance 
	HAVING SUM(tblDailySnapshot.Loan) > 400;



-- 6) 

SELECT TOP 10 tblClients.Last_Name, tblClients.First_Name, SUM(tblBalances.Balance) FROM tblAccounts
	INNER JOIN tblClients ON tblAccounts.FK_Client=tblClients.PK_Clients
	INNER JOIN tblTransactions ON tblAccounts.PK_Accounts=tblTransactions.FK_Account_Sender
	INNER JOIN tblBalances ON tblTransactions.FK_Balance=tblBalances.PK_Balances
	GROUP BY tblClients.Last_Name ORDER BY SUM(tblBalances.Balance) DESC;