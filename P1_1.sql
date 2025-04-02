create database Shop

use Shop

create Table Clientes (
	Cl_ID int primary key identity (1,1) not null
);

create Table Pedidos (  
	Ped_ID int primary key identity (1,1) not null,
	Ped_Date date default GetDate() not null
);

create Table Art�culos (
	A_ID int primary key identity (1,1) not null,
	A_Name varchar(20),
	A_Descr varchar(200),
	A_Cost decimal(10,2),
	A_Stock int
);

create Table PedidoArt�culos (
	Cl_ID int,
	Ped_ID int,
	A_ID int,
	Quant int,
	Tot_Cost decimal,
	Primary key (Cl_ID, Ped_ID, A_ID),
	Foreign key (Cl_ID) References Clientes(Cl_ID),
	Foreign key (Ped_ID) References Pedidos(Ped_ID),
	Foreign key (A_ID) References Art�culos(A_ID)
);

Go

create trigger CheckStockOnPedidoArticulos 
on PedidoArt�culos
after insert, Update
as
begin
    if Exists (
        select 1
        from PedidoArt�culos pa
        Inner Join Art�culos a on pa.A_ID = a.A_ID
        Inner Join inserted i on pa.Cl_ID = i.Cl_ID and pa.Ped_ID = i.Ped_ID and pa.A_ID = i.A_ID
        WHERE i.Quant > a.A_Stock
    )
    begin
        Raiserror ('No hay suficiente stock disponible para uno o m�s art�culos.', 16, 1);
        Rollback Transaction;
        return;
    end
end;

Go

Update pa
Set pa.Tot_Cost = pa.Quant * a.A_Cost
From PedidoArt�culos pa
Inner Join Art�culos a on pa.A_ID = a.A_ID;
	