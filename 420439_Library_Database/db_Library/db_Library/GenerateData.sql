USE [db_Library]
GO
SET IDENTITY_INSERT [dbo].[Books] ON 
GO
INSERT [dbo].[Books] ([BookId], [CategoryId], [Title]) VALUES (1, NULL, N'LifeStyle')
GO
INSERT [dbo].[Books] ([BookId], [CategoryId], [Title]) VALUES (2, NULL, N'GoodJob')
GO
INSERT [dbo].[Books] ([BookId], [CategoryId], [Title]) VALUES (3, NULL, N'The Reason Of SuccessAndFailure')
GO
INSERT [dbo].[Books] ([BookId], [CategoryId], [Title]) VALUES (4, NULL, N'Derakula')
GO
INSERT [dbo].[Books] ([BookId], [CategoryId], [Title]) VALUES (5, NULL, N'Allah')
GO
INSERT [dbo].[Books] ([BookId], [CategoryId], [Title]) VALUES (6, NULL, N'Ali')
GO
SET IDENTITY_INSERT [dbo].[Books] OFF
GO
SET IDENTITY_INSERT [dbo].[Publishers] ON 
GO
INSERT [dbo].[Publishers] ([PublisherId], [Name], [Address]) VALUES (1, N'IranTomorrow', N'Tehran-Enghelab Squre')
GO
INSERT [dbo].[Publishers] ([PublisherId], [Name], [Address]) VALUES (2, N'Navaye Aramesh', N'Tehran-Valieasre Street')
GO
INSERT [dbo].[Publishers] ([PublisherId], [Name], [Address]) VALUES (3, N'Sarzamin Khorshid', N'Tehran-Fallah Street')
GO
SET IDENTITY_INSERT [dbo].[Publishers] OFF
GO
INSERT [dbo].[BookCopies] ([ISBN], [BookId], [PublisherId], [PublishDate], [EditedVersion], [Price]) VALUES (N'1', 1, 1, CAST(N'2023-01-01T00:00:00.000' AS DateTime), 1, CAST(1000 AS Decimal(18, 0)))
GO
INSERT [dbo].[BookCopies] ([ISBN], [BookId], [PublisherId], [PublishDate], [EditedVersion], [Price]) VALUES (N'2', 2, 1, CAST(N'2023-02-01T00:00:00.000' AS DateTime), 2, CAST(5000 AS Decimal(18, 0)))
GO
INSERT [dbo].[BookCopies] ([ISBN], [BookId], [PublisherId], [PublishDate], [EditedVersion], [Price]) VALUES (N'3', 3, 2, CAST(N'2020-02-02T00:00:00.000' AS DateTime), 10, CAST(55000 AS Decimal(18, 0)))
GO
INSERT [dbo].[BookCopies] ([ISBN], [BookId], [PublisherId], [PublishDate], [EditedVersion], [Price]) VALUES (N'4', 4, 2, CAST(N'2019-05-27T00:00:00.000' AS DateTime), 3, CAST(45000 AS Decimal(18, 0)))
GO
INSERT [dbo].[BookCopies] ([ISBN], [BookId], [PublisherId], [PublishDate], [EditedVersion], [Price]) VALUES (N'5', 5, 1, CAST(N'2010-01-10T00:00:00.000' AS DateTime), 2, CAST(20000 AS Decimal(18, 0)))
GO
INSERT [dbo].[BookCopies] ([ISBN], [BookId], [PublisherId], [PublishDate], [EditedVersion], [Price]) VALUES (N'6', 6, 2, CAST(N'2000-01-01T00:00:00.000' AS DateTime), 50, CAST(4000 AS Decimal(18, 0)))
GO
SET IDENTITY_INSERT [dbo].[People] ON 
GO
INSERT [dbo].[People] ([PersonId], [Name], [Family], [PhoneNo], [Email], [Address]) VALUES (1, N'Mehrdad', N'Paki', NULL, NULL, NULL)
GO
INSERT [dbo].[People] ([PersonId], [Name], [Family], [PhoneNo], [Email], [Address]) VALUES (2, N'Hassan', N'Ardeshir', NULL, NULL, NULL)
GO
INSERT [dbo].[People] ([PersonId], [Name], [Family], [PhoneNo], [Email], [Address]) VALUES (3, N'Ali', N'Ghazvini', NULL, NULL, NULL)
GO
INSERT [dbo].[People] ([PersonId], [Name], [Family], [PhoneNo], [Email], [Address]) VALUES (4, N'Mehdi', N'Ghole', NULL, NULL, NULL)
GO
INSERT [dbo].[People] ([PersonId], [Name], [Family], [PhoneNo], [Email], [Address]) VALUES (5, N'Amin', N'Rostami', NULL, NULL, NULL)
GO
INSERT [dbo].[People] ([PersonId], [Name], [Family], [PhoneNo], [Email], [Address]) VALUES (6, N'Mohammad', N'Bandari', NULL, NULL, NULL)
GO
INSERT [dbo].[People] ([PersonId], [Name], [Family], [PhoneNo], [Email], [Address]) VALUES (7, N'AmirHossein', N'Basati', NULL, NULL, NULL)
GO
INSERT [dbo].[People] ([PersonId], [Name], [Family], [PhoneNo], [Email], [Address]) VALUES (8, N'Morteza', N'Harandi', NULL, NULL, NULL)
GO
INSERT [dbo].[People] ([PersonId], [Name], [Family], [PhoneNo], [Email], [Address]) VALUES (9, N'Kamran', N'Najafi', NULL, NULL, NULL)
GO
INSERT [dbo].[People] ([PersonId], [Name], [Family], [PhoneNo], [Email], [Address]) VALUES (10, N'Mohsen', N'Hashemi', NULL, NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[People] OFF
GO
INSERT [dbo].[Staffs] ([StaffId]) VALUES (4)
GO
INSERT [dbo].[Staffs] ([StaffId]) VALUES (5)
GO
INSERT [dbo].[Readers] ([ReaderId]) VALUES (1)
GO
INSERT [dbo].[Readers] ([ReaderId]) VALUES (2)
GO
INSERT [dbo].[Readers] ([ReaderId]) VALUES (3)
GO
SET IDENTITY_INSERT [dbo].[BorrowBookCopies] ON 
GO
INSERT [dbo].[BorrowBookCopies] ([BorrowId], [ISBN], [StaffId], [ReaderId], [BorrowedDateTime], [DeadlineDateTime], [ReturnDateTime]) VALUES (2, N'1', 4, 1, CAST(N'2023-01-01T00:00:00.000' AS DateTime), CAST(N'2023-01-03T00:00:00.000' AS DateTime), CAST(N'2023-01-03T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[BorrowBookCopies] ([BorrowId], [ISBN], [StaffId], [ReaderId], [BorrowedDateTime], [DeadlineDateTime], [ReturnDateTime]) VALUES (4, N'2', 4, 1, CAST(N'2023-01-10T00:00:00.000' AS DateTime), CAST(N'2023-01-30T00:00:00.000' AS DateTime), CAST(N'2023-01-28T00:00:00.000' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[BorrowBookCopies] OFF
GO
INSERT [dbo].[StaffHoldBookCopies] ([StaffId], [ISBN]) VALUES (4, N'1')
GO
INSERT [dbo].[StaffHoldBookCopies] ([StaffId], [ISBN]) VALUES (4, N'2')
GO
INSERT [dbo].[StaffHoldBookCopies] ([StaffId], [ISBN]) VALUES (4, N'4')
GO
INSERT [dbo].[StaffHoldBookCopies] ([StaffId], [ISBN]) VALUES (5, N'3')
GO
INSERT [dbo].[StaffHoldBookCopies] ([StaffId], [ISBN]) VALUES (5, N'5')
GO
INSERT [dbo].[Authers] ([AutherId]) VALUES (8)
GO
INSERT [dbo].[Authers] ([AutherId]) VALUES (9)
GO
INSERT [dbo].[Authers] ([AutherId]) VALUES (10)
GO
INSERT [dbo].[AutherBookCopies] ([AutherId], [ISBN], [OrderNumber]) VALUES (8, N'1', 2)
GO
INSERT [dbo].[AutherBookCopies] ([AutherId], [ISBN], [OrderNumber]) VALUES (8, N'3', 2)
GO
INSERT [dbo].[AutherBookCopies] ([AutherId], [ISBN], [OrderNumber]) VALUES (9, N'1', 1)
GO
INSERT [dbo].[AutherBookCopies] ([AutherId], [ISBN], [OrderNumber]) VALUES (9, N'3', 3)
GO
INSERT [dbo].[AutherBookCopies] ([AutherId], [ISBN], [OrderNumber]) VALUES (10, N'2', 1)
GO
INSERT [dbo].[AutherBookCopies] ([AutherId], [ISBN], [OrderNumber]) VALUES (10, N'3', 1)
GO
