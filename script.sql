USE [master]
GO
/****** Object:  Database [u_petryla]    Script Date: 2024-04-07 14:11:15 ******/
CREATE DATABASE [u_petryla]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'u_petryla', FILENAME = N'/var/opt/mssql/data/u_petryla.mdf' , SIZE = 73728KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'u_petryla_log', FILENAME = N'/var/opt/mssql/data/u_petryla_log.ldf' , SIZE = 66048KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [u_petryla] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [u_petryla].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [u_petryla] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [u_petryla] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [u_petryla] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [u_petryla] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [u_petryla] SET ARITHABORT OFF 
GO
ALTER DATABASE [u_petryla] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [u_petryla] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [u_petryla] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [u_petryla] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [u_petryla] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [u_petryla] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [u_petryla] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [u_petryla] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [u_petryla] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [u_petryla] SET  ENABLE_BROKER 
GO
ALTER DATABASE [u_petryla] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [u_petryla] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [u_petryla] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [u_petryla] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [u_petryla] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [u_petryla] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [u_petryla] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [u_petryla] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [u_petryla] SET  MULTI_USER 
GO
ALTER DATABASE [u_petryla] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [u_petryla] SET DB_CHAINING OFF 
GO
ALTER DATABASE [u_petryla] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [u_petryla] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [u_petryla] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [u_petryla] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [u_petryla] SET QUERY_STORE = OFF
GO
USE [u_petryla]
GO
/****** Object:  DatabaseRole [WebinarMember]    Script Date: 2024-04-07 14:11:16 ******/
CREATE ROLE [WebinarMember]
GO
/****** Object:  DatabaseRole [UnregisteredUser]    Script Date: 2024-04-07 14:11:17 ******/
CREATE ROLE [UnregisteredUser]
GO
/****** Object:  DatabaseRole [Translator]    Script Date: 2024-04-07 14:11:17 ******/
CREATE ROLE [Translator]
GO
/****** Object:  DatabaseRole [StudiesMember]    Script Date: 2024-04-07 14:11:17 ******/
CREATE ROLE [StudiesMember]
GO
/****** Object:  DatabaseRole [Professor]    Script Date: 2024-04-07 14:11:17 ******/
CREATE ROLE [Professor]
GO
/****** Object:  DatabaseRole [Principal]    Script Date: 2024-04-07 14:11:17 ******/
CREATE ROLE [Principal]
GO
/****** Object:  DatabaseRole [OfficeWorker]    Script Date: 2024-04-07 14:11:17 ******/
CREATE ROLE [OfficeWorker]
GO
/****** Object:  DatabaseRole [InternshipOffice]    Script Date: 2024-04-07 14:11:18 ******/
CREATE ROLE [InternshipOffice]
GO
/****** Object:  DatabaseRole [CourseMember]    Script Date: 2024-04-07 14:11:18 ******/
CREATE ROLE [CourseMember]
GO
/****** Object:  DatabaseRole [admin]    Script Date: 2024-04-07 14:11:18 ******/
CREATE ROLE [admin]
GO
/****** Object:  UserDefinedFunction [dbo].[funcGetAvgSubjectMark]    Script Date: 2024-04-07 14:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[funcGetAvgSubjectMark] (@SubjectID int) RETURNS decimal(3,2) AS BEGIN DECLARE @output decimal
SET @output =
  	(SELECT AVG(mark)
	FROM Results r
	INNER JOIN Exams e on e.exam_id	= r.exam_id
	INNER JOIN Subjects s on s.subject_id = e.subject_id
	WHERE s.subject_id = @SubjectID
	) RETURN @output END
GO
/****** Object:  UserDefinedFunction [dbo].[funcGetProfessorLanguage]    Script Date: 2024-04-07 14:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[funcGetProfessorLanguage] (@first_name nvarchar(50), @last_name nvarchar(50)) RETURNS nvarchar(15) AS 
BEGIN DECLARE @output nvarchar(50)
SET @output =
  (select l.language_name from users u inner join professors p on p.user_id = u.user_id
inner join languages l on p.language_id = l.language_id
where u.first_name = @first_name and u.last_name = @last_name) RETURN @output
 END
GO
/****** Object:  UserDefinedFunction [dbo].[funcNumberOfCoursesMembers]    Script Date: 2024-04-07 14:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[funcNumberOfCoursesMembers](@CourseName nvarchar(30))
returns int as
BEGIN
DECLARE @output int
SET @output = (
   		SELECT COUNT(*) 
   		FROM CourseMembers cm
   		INNER JOIN Courses c ON c.course_id = cm.course_id
   		WHERE c.course_name = @CourseName)
RETURN @output
END
GO
/****** Object:  UserDefinedFunction [dbo].[funcNumberOfStudiesMembers]    Script Date: 2024-04-07 14:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	
CREATE FUNCTION [dbo].[funcNumberOfStudiesMembers](@StudiesName nvarchar(30))
returns int as 
BEGIN
DECLARE @output int
SET @output = (
	SELECT COUNT(*)
	FROM StudiesMembers sm
	INNER JOIN Studies s ON s.studies_id = sm.studies_id
	WHERE s.studies_name = @StudiesName)
RETURN @output
END
GO
/****** Object:  UserDefinedFunction [dbo].[funcNumberOfWebinarMembers]    Script Date: 2024-04-07 14:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[funcNumberOfWebinarMembers](@WebinarName nvarchar(30)) RETURNS int AS BEGIN DECLARE @output int
SET @output =
  (SELECT COUNT(*)
   FROM WebinarMembers wm
   INNER JOIN Webinars w ON w.webinar_id = wm.webinar_id
   WHERE w.webinar_name = @WebinarName) RETURN @output END
GO
/****** Object:  UserDefinedFunction [dbo].[GetExamID]    Script Date: 2024-04-07 14:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetExamID](@subject_name nvarchar(10))
RETURNS int
AS
BEGIN
    DECLARE @exam_id int;

    -- Uzyskaj exam_id na podstawie subject_name
    SELECT @exam_id = e.exam_id
    FROM Exams e
    INNER JOIN Subjects s ON e.subject_id = s.subject_id
    WHERE s.subject_name = @subject_name;

    RETURN @exam_id;
END;
GO
/****** Object:  UserDefinedFunction [dbo].[getUserID]    Script Date: 2024-04-07 14:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[getUserID] (@first_name nvarchar(50), @last_name nvarchar(50))
RETURNS int
AS
BEGIN
    DECLARE @user_id int;

    SELECT @user_id = user_id
    FROM Users
    WHERE first_name = @first_name AND last_name = @last_name;

    RETURN @user_id;
END;
GO
/****** Object:  Table [dbo].[Courses]    Script Date: 2024-04-07 14:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Courses](
	[course_id] [int] NOT NULL,
	[course_name] [nvarchar](50) NULL,
	[price] [money] NOT NULL,
	[start_date] [datetime] NOT NULL,
	[end_date] [datetime] NOT NULL,
	[installment_amount] [money] NOT NULL,
 CONSTRAINT [Courses_pk] PRIMARY KEY CLUSTERED 
(
	[course_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CourseMembers]    Script Date: 2024-04-07 14:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CourseMembers](
	[user_id] [int] NOT NULL,
	[course_id] [int] NOT NULL,
	[passed] [bit] NULL,
 CONSTRAINT [CourseMembers_pk] PRIMARY KEY CLUSTERED 
(
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Modules]    Script Date: 2024-04-07 14:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Modules](
	[module_id] [int] NOT NULL,
	[course_id] [int] NOT NULL,
	[professor_id] [int] NOT NULL,
	[domain] [nvarchar](50) NOT NULL,
	[date] [datetime] NOT NULL,
	[mode_id] [int] NOT NULL,
 CONSTRAINT [Modules_pk] PRIMARY KEY CLUSTERED 
(
	[module_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ModuleParticipantsLimit]    Script Date: 2024-04-07 14:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ModuleParticipantsLimit](
	[module_id] [int] NOT NULL,
	[participants_limit] [int] NOT NULL,
 CONSTRAINT [ModuleParticipantsLimit_pk] PRIMARY KEY CLUSTERED 
(
	[module_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[AvailableCourses]    Script Date: 2024-04-07 14:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[AvailableCourses] AS
SELECT
    c.course_id,
    c.course_name,
    c.price,
    c.start_date,
    c.end_date,
    c.installment_amount
FROM
    Courses c
WHERE NOT EXISTS (
    SELECT 1
    FROM Modules m
    INNER JOIN CourseMembers cm ON cm.course_id = m.course_id
    LEFT JOIN ModuleParticipantsLimit mpl ON m.module_id = mpl.module_id
    WHERE m.course_id = c.course_id
    GROUP BY m.course_id, mpl.participants_limit
    HAVING (mpl.participants_limit < ISNULL(COUNT(cm.user_id),0))
 
)
AND c.start_date > GETDATE()
GO
/****** Object:  Table [dbo].[SubjectsSchedule]    Script Date: 2024-04-07 14:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SubjectsSchedule](
	[subject_id] [int] NOT NULL,
	[week_day] [nvarchar](10) NOT NULL,
	[time] [time](5) NOT NULL,
	[date] [datetime] NOT NULL,
	[convention_id] [int] NOT NULL,
 CONSTRAINT [SubjectsSchedule_pk] PRIMARY KEY CLUSTERED 
(
	[subject_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ModeDetails]    Script Date: 2024-04-07 14:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ModeDetails](
	[mode_id] [int] NOT NULL,
	[mode_name] [nvarchar](20) NOT NULL,
 CONSTRAINT [ModeDetails_pk] PRIMARY KEY CLUSTERED 
(
	[mode_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Studies]    Script Date: 2024-04-07 14:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Studies](
	[studies_id] [int] NOT NULL,
	[studies_name] [nvarchar](30) NOT NULL,
	[price] [money] NOT NULL,
	[mode_id] [int] NOT NULL,
	[participants_limit] [int] NOT NULL,
 CONSTRAINT [Studies_pk] PRIMARY KEY CLUSTERED 
(
	[studies_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[StudiesMembers]    Script Date: 2024-04-07 14:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StudiesMembers](
	[user_id] [int] NOT NULL,
	[studies_id] [int] NOT NULL,
	[passed] [bit] NULL,
	[is_student] [bit] NOT NULL,
 CONSTRAINT [StudiesMembers_pk] PRIMARY KEY CLUSTERED 
(
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Subjects]    Script Date: 2024-04-07 14:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Subjects](
	[subject_id] [int] NOT NULL,
	[studies_id] [int] NOT NULL,
	[professor_id] [int] NOT NULL,
	[subject_name] [nvarchar](50) NULL,
 CONSTRAINT [Subjects_pk] PRIMARY KEY CLUSTERED 
(
	[subject_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[AvailableStudies]    Script Date: 2024-04-07 14:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[AvailableStudies] AS
SELECT
    s.studies_id,
    s.studies_name,
    md.mode_name,
    s.price,
    ss.date AS start_date
FROM Studies s
INNER JOIN ModeDetails md ON s.mode_id = md.mode_id
INNER JOIN Subjects sb ON sb.studies_id = s.studies_id
INNER JOIN SubjectsSchedule ss ON ss.subject_id = sb.subject_id
WHERE
	(SELECT COUNT(*) FROM StudiesMembers sm
	WHERE is_student = 1
	AND sm.studies_id = s.studies_id) < s.participants_limit 
	AND  ss.date > GETDATE()
GO
/****** Object:  Table [dbo].[Professors]    Script Date: 2024-04-07 14:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Professors](
	[professor_id] [int] NOT NULL,
	[user_id] [int] NOT NULL,
	[academic_title] [nvarchar](10) NOT NULL,
	[language_id] [int] NOT NULL,
 CONSTRAINT [Professors_pk] PRIMARY KEY CLUSTERED 
(
	[professor_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Webinars]    Script Date: 2024-04-07 14:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Webinars](
	[webinar_id] [int] NOT NULL,
	[webinar_name] [nvarchar](50) NOT NULL,
	[video_link] [nvarchar](50) NOT NULL,
	[price] [money] NOT NULL,
	[professor_id] [int] NOT NULL,
	[webinar_date] [datetime] NULL,
 CONSTRAINT [Webinars_pk] PRIMARY KEY CLUSTERED 
(
	[webinar_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Users]    Script Date: 2024-04-07 14:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[user_id] [int] NOT NULL,
	[first_name] [nvarchar](50) NOT NULL,
	[last_name] [nvarchar](50) NOT NULL,
	[date_of_birth] [date] NOT NULL,
	[email] [nvarchar](50) NOT NULL,
 CONSTRAINT [Users_pk] PRIMARY KEY CLUSTERED 
(
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [Users_emailUnique] UNIQUE NONCLUSTERED 
(
	[email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[ProfessorsSchedule]    Script Date: 2024-04-07 14:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 CREATE VIEW [dbo].[ProfessorsSchedule] AS
   select p.professor_id, u.first_name, u.last_name,  events.type, events.event_name, events.date

   from users u 
   inner join professors p on u.user_id = p.user_id
   inner join 

   (
select p.professor_id, 'subject' as type, s.subject_name as event_name,
CONVERT(datetime, CONVERT(varchar, date, 23) + ' ' + CONVERT(varchar, time, 108), 121)  AS date from  
Professors p
inner join
subjects s on p.professor_id = s.professor_id
inner join subjectsschedule ss on ss.subject_id = s.subject_id
union all 
select p.professor_id, 'webinar' as type, w.webinar_name as event_name, webinar_date date from Professors p
inner join webinars w on p.professor_id = w.professor_id
union all
select p.professor_id, 'module' as type, m.domain as event_name, m.date date from Professors p
inner join Modules m on p.professor_id = m.professor_id) EVENTS
on events.professor_id = p.professor_id
GO
/****** Object:  Table [dbo].[Conventions]    Script Date: 2024-04-07 14:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Conventions](
	[convention_id] [int] NOT NULL,
	[date] [date] NOT NULL,
	[price] [money] NOT NULL,
	[students_price] [money] NOT NULL,
	[individual_participants_limit] [int] NOT NULL,
 CONSTRAINT [Conventions_pk] PRIMARY KEY CLUSTERED 
(
	[convention_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ConventionsPayments]    Script Date: 2024-04-07 14:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ConventionsPayments](
	[user_id] [int] NOT NULL,
	[convention_id] [int] NOT NULL,
	[payment_date] [int] NOT NULL,
	[paid_amount] [money] NULL,
 CONSTRAINT [ConventionsPayments_pk] PRIMARY KEY CLUSTERED 
(
	[user_id] ASC,
	[convention_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[AvailableConventions]    Script Date: 2024-04-07 14:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[AvailableConventions] AS
SELECT
    c.convention_id,
   	c.date,
   	c.price,
   	c.students_price
FROM Conventions c
INNER JOIN ConventionsPayments cp ON c.convention_id = cp.convention_id
WHERE c.date > GETDATE()
GROUP BY
   	c.convention_id,
   	c.date,
   	c.price,
   	c.students_price,
   	c.individual_participants_limit
HAVING c.individual_participants_limit > ISNULL(COUNT(cp.user_id),0)
GO
/****** Object:  Table [dbo].[ModuleTranslators]    Script Date: 2024-04-07 14:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ModuleTranslators](
	[module_id] [int] NOT NULL,
	[translator_id] [int] NOT NULL,
 CONSTRAINT [ModuleTranslators_pk] PRIMARY KEY CLUSTERED 
(
	[module_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[WebinarTranslators]    Script Date: 2024-04-07 14:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WebinarTranslators](
	[webinar_id] [int] NOT NULL,
	[translator_id] [int] NOT NULL,
 CONSTRAINT [WebinarTranslators_pk] PRIMARY KEY CLUSTERED 
(
	[webinar_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SubjectTranslators]    Script Date: 2024-04-07 14:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SubjectTranslators](
	[translator_id] [int] NOT NULL,
	[subject_id] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Translators]    Script Date: 2024-04-07 14:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Translators](
	[translator_id] [int] NOT NULL,
	[first_name] [nvarchar](50) NOT NULL,
	[last_name] [nvarchar](50) NOT NULL,
 CONSTRAINT [Translators_pk] PRIMARY KEY CLUSTERED 
(
	[translator_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[translatorsschedule]    Script Date: 2024-04-07 14:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[translatorsschedule] as
select t.translator_id, first_name, last_name, events.type, events.event_name, events.date from translators t
inner join 
(
select mt.translator_id, 'module' as type, domain as event_name, date from
ModuleTranslators mt
inner join
modules m 
on mt.module_id = m.module_id
union all
select translator_id, 'webinar' as type, webinar_name as event_name, webinar_date as date from WebinarTranslators wt
inner join Webinars w 
on wt.webinar_id = w.webinar_id
union all
select translator_id, 'subject' as type, subject_name as event_name, ss.date as date from SubjectTranslators st
inner join Subjects s 
on s.subject_id = st.subject_id
inner join SubjectsSchedule ss
on ss.subject_id = st.subject_id
) events
on events.translator_id = t.translator_id
GO
/****** Object:  UserDefinedFunction [dbo].[funcGetTranslatorSchedule]    Script Date: 2024-04-07 14:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[funcGetTranslatorSchedule](
    @translator_id INT,
    @date_from DATE,
    @date_to DATE
)
RETURNS TABLE
AS
RETURN (
    SELECT *
    FROM TranslatorsSchedule
    WHERE translator_id = @translator_id
        AND date BETWEEN @date_from AND @date_to
);
GO
/****** Object:  Table [dbo].[WebinarsOrders]    Script Date: 2024-04-07 14:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WebinarsOrders](
	[order_id] [int] NOT NULL,
	[webinar_id] [int] NOT NULL,
 CONSTRAINT [WebinarsOrders_pk] PRIMARY KEY CLUSTERED 
(
	[order_id] ASC,
	[webinar_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[WebinarsRevenue]    Script Date: 2024-04-07 14:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[WebinarsRevenue] AS
SELECT
    w.webinar_name,
    w.price * ISNULL(o.order_count, 0) AS total_revenue
FROM
    Webinars w
LEFT JOIN (
    SELECT
        webinar_id,
        COUNT(*) AS order_count
    FROM
        WebinarsOrders
    GROUP BY
        webinar_id
) o ON w.webinar_id = o.webinar_id;

GO
/****** Object:  UserDefinedFunction [dbo].[funcUserCourses]    Script Date: 2024-04-07 14:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[funcUserCourses] (@UserID int)
returns table as return
SELECT course_name FROM Courses c
INNER JOIN CourseMembers cm ON cm.course_id = c.course_id
WHERE cm.user_id = @UserID
GO
/****** Object:  Table [dbo].[WebinarMembers]    Script Date: 2024-04-07 14:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WebinarMembers](
	[user_id] [int] NOT NULL,
	[webinar_id] [int] NOT NULL,
	[access_date_from] [datetime] NOT NULL,
	[access_date_to] [datetime] NOT NULL,
 CONSTRAINT [WebinarMembers_pk] PRIMARY KEY CLUSTERED 
(
	[user_id] ASC,
	[webinar_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[funcUserWebinars]    Script Date: 2024-04-07 14:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	CREATE FUNCTION [dbo].[funcUserWebinars] (@UserID int)
	returns table as return
	SELECT webinar_name FROM Webinars w
	INNER JOIN WebinarMembers wm ON wm.webinar_id = w.webinar_id
	WHERE wm.user_id = @UserID
GO
/****** Object:  UserDefinedFunction [dbo].[funcUserStudies]    Script Date: 2024-04-07 14:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	CREATE FUNCTION [dbo].[funcUserStudies] (@UserID int)
	returns table as return
	SELECT studies_name FROM Studies s
	INNER JOIN StudiesMembers sm ON sm.studies_id = s.studies_id
	WHERE sm.user_id = @UserID
GO
/****** Object:  View [dbo].[FreeWebinars]    Script Date: 2024-04-07 14:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[FreeWebinars] AS
SELECT webinar_id,
	webinar_name,
   	webinar_date,
   	u.first_name + ' ' + u.last_name AS professor
FROM Webinars w
INNER JOIN Professors p ON p.professor_id = w.professor_id
INNER JOIN Users u ON u.user_id = p.user_id
WHERE price = 0
GO
/****** Object:  Table [dbo].[CoursesPayments]    Script Date: 2024-04-07 14:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CoursesPayments](
	[course_id] [int] NOT NULL,
	[user_id] [int] NOT NULL,
	[paid_amount] [int] NULL,
	[payment_date] [datetime] NOT NULL,
 CONSTRAINT [CoursePayments_pk] PRIMARY KEY CLUSTERED 
(
	[course_id] ASC,
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[CoursesRevenue]    Script Date: 2024-04-07 14:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[CoursesRevenue] AS
SELECT c.course_name, 
   	(SELECT SUM(paid_amount)
    FROM CoursesPayments cp
	where cp.course_id = c.course_id
    GROUP BY cp.course_id
	) AS total_revenue
FROM Courses c
GO
/****** Object:  Table [dbo].[Internships]    Script Date: 2024-04-07 14:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Internships](
	[user_id] [int] NOT NULL,
	[start_date] [datetime] NOT NULL,
	[end_date] [datetime] NOT NULL,
	[passed] [bit] NULL,
 CONSTRAINT [Internships_pk] PRIMARY KEY CLUSTERED 
(
	[user_id] ASC,
	[start_date] ASC,
	[end_date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[CompletedInternships]    Script Date: 2024-04-07 14:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[CompletedInternships] AS
SELECT u.first_name,
   	u.last_name,
   	s.studies_name,
   	i.start_date,
   	i.end_date
FROM Users u
INNER JOIN StudiesMembers sm ON u.user_id = sm.user_id
INNER JOIN Studies s ON s.studies_id = sm.studies_id
INNER JOIN Internships i ON i.user_id = sm.user_id
WHERE i.passed = 1
GROUP BY u.first_name,
       u.last_name,
       s.studies_name,
       i.start_date,
       i.end_date
GO
/****** Object:  View [dbo].[FutureWebinarsMembers]    Script Date: 2024-04-07 14:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[FutureWebinarsMembers] AS
SELECT w.webinar_name,
	ISNULL((SELECT COUNT(*)
	FROM WebinarMembers wb
	WHERE wb.webinar_id = w.webinar_id
	GROUP BY wb.webinar_id),0) AS members_number
FROM Webinars w
WHERE w.webinar_date > GETDATE()
GO
/****** Object:  View [dbo].[FutureCoursesMembers]    Script Date: 2024-04-07 14:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[FutureCoursesMembers] AS
SELECT c.course_name,
	ISNULL((SELECT COUNT(*)
	FROM CourseMembers cm
	WHERE cm.course_id = c.course_id
	GROUP BY cm.course_id),0) AS members_number
FROM Courses c
WHERE c.start_date > GETDATE()
GO
/****** Object:  UserDefinedFunction [dbo].[funcFreePlacesCoursesModules]    Script Date: 2024-04-07 14:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[funcFreePlacesCoursesModules] (@course_id int, @module_id int) RETURNS TABLE AS RETURN
SELECT participants_limit - count(DISTINCT cm.user_id) AS free_places
FROM Modules m
INNER JOIN CourseMembers cm ON cm.course_id = m.course_id
INNER JOIN ModuleParticipantsLimit mpl ON mpl.module_id = m.module_id
WHERE cm.course_id = @course_id
  AND m.module_id = @module_id
GROUP BY cm.course_id,
         m.module_id,
         m.domain,
     	participants_limit
GO
/****** Object:  Table [dbo].[Countries]    Script Date: 2024-04-07 14:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Countries](
	[country_id] [int] NOT NULL,
	[country_name] [nvarchar](50) NOT NULL,
 CONSTRAINT [Countries_pk] PRIMARY KEY CLUSTERED 
(
	[country_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [country_nameUnique] UNIQUE NONCLUSTERED 
(
	[country_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Cities]    Script Date: 2024-04-07 14:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Cities](
	[city_id] [int] NOT NULL,
	[city_name] [nvarchar](50) NOT NULL,
	[country_id] [int] NOT NULL,
 CONSTRAINT [Cities_pk] PRIMARY KEY CLUSTERED 
(
	[city_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [city_nameUnique] UNIQUE NONCLUSTERED 
(
	[city_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UsersAddresses]    Script Date: 2024-04-07 14:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UsersAddresses](
	[user_id] [int] NOT NULL,
	[street_prefix] [nvarchar](3) NOT NULL,
	[street_name] [nvarchar](50) NOT NULL,
	[building_no] [nvarchar](10) NOT NULL,
	[postal_code] [nvarchar](6) NOT NULL,
	[city_id] [int] NOT NULL,
 CONSTRAINT [UsersAddresses_pk] PRIMARY KEY CLUSTERED 
(
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[ShippingAddresses]    Script Date: 2024-04-07 14:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[ShippingAddresses] AS
SELECT u.user_id,
       u.first_name,
       u.last_name,
       ua.street_prefix + '  '+ ua.street_name + ' ' + ua.building_no AS street,
       ua.postal_code,
       c.city_name,
       co.country_name
FROM Users u
INNER JOIN StudiesMembers sm on u.user_id = sm.User_id and sm.passed = 1
INNER JOIN UsersAddresses ua ON u.user_id = ua.user_id
INNER JOIN Cities c ON ua.city_id = c.city_id
INNER JOIN Countries co ON co.country_id = c.country_id
GO
/****** Object:  UserDefinedFunction [dbo].[funcFreePlacesStudies]    Script Date: 2024-04-07 14:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[funcFreePlacesStudies] (@studies_id int) RETURNS TABLE AS RETURN
SELECT s.participants_limit - count(DISTINCT sm.user_id) AS free_places
FROM Studies s
LEFT JOIN StudiesMembers sm ON sm.studies_id = s.studies_id
WHERE s.studies_id = 20
GROUP BY s.studies_id,
         participants_limit
GO
/****** Object:  UserDefinedFunction [dbo].[funcMyEvents]    Script Date: 2024-04-07 14:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[funcMyEvents] (@first_name nvarchar(50), @last_name nvarchar(50), @date_from date, @date_to date)
   	returns table as return

select 'Subject on studies' as type_of_event, studies_name as event_name, subject_name as content_details,  cast(ss.date as date) as date, ss.time
from Users u
inner join StudiesMembers sm on u.user_id = sm.user_id
inner join Studies s on s.studies_id = sm.studies_id 
inner join Subjects su on su.studies_id = s.studies_id
inner join SubjectsSchedule ss on ss.subject_id = su.subject_id
inner join Conventions c on c.convention_id = ss.convention_id
where u.first_name = @first_name and u.last_name = @last_name
and ss.date between @date_from and @date_to

union all

select 'Module in the course' as type_of_event, course_name as event_name, domain as content_details, cast(m.date as date) as date, cast(m.date as time) as time
from Users u
inner join CourseMembers cm on u.user_id = cm.user_id
inner join Courses c on c.course_id = cm.course_id 
inner join Modules m on m.course_id = c.course_id
where u.first_name = @first_name and u.last_name = @last_name
and m.date between  @date_from and  @date_to

union all

select 'Webinar - live' as type_of_event, webinar_name as event_name, video_link as content_details, cast(w.webinar_date as date) as date, cast(w.webinar_date as time) as time
from Users u
inner join WebinarMembers wm on u.user_id = wm.user_id
inner join Webinars w on w.webinar_id = wm.webinar_id 
where u.first_name = @first_name and u.last_name = @last_name
and w.webinar_date between  @date_from and  @date_to
GO
/****** Object:  Table [dbo].[Orders]    Script Date: 2024-04-07 14:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Orders](
	[order_id] [int] NOT NULL,
	[user_id] [int] NOT NULL,
 CONSTRAINT [Orders_pk] PRIMARY KEY CLUSTERED 
(
	[order_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ConventionsOrders]    Script Date: 2024-04-07 14:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ConventionsOrders](
	[order_id] [int] NOT NULL,
	[convention_id] [int] NOT NULL,
 CONSTRAINT [ConventionsOrders_pk] PRIMARY KEY CLUSTERED 
(
	[order_id] ASC,
	[convention_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[UsersDebtConventions]    Script Date: 2024-04-07 14:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[UsersDebtConventions] as
select o.user_id , co.convention_id, c.price - cp.paid_amount as debt
from Orders o
inner join ConventionsOrders co on o.order_id = co.order_id
inner join Conventions c on co.convention_id = c.convention_id
left join ConventionsPayments cp on o.user_id = cp.user_id and c.convention_id = cp.convention_id
where  c.price - cp.paid_amount <> 0 
GO
/****** Object:  Table [dbo].[StudiesOrders]    Script Date: 2024-04-07 14:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StudiesOrders](
	[order_id] [int] NOT NULL,
	[studies_id] [int] NOT NULL,
 CONSTRAINT [StudiesOrders_pk] PRIMARY KEY CLUSTERED 
(
	[order_id] ASC,
	[studies_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CoursesOrders]    Script Date: 2024-04-07 14:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CoursesOrders](
	[order_id] [int] NOT NULL,
	[course_id] [int] NOT NULL,
 CONSTRAINT [CoursesOrders_pk] PRIMARY KEY CLUSTERED 
(
	[order_id] ASC,
	[course_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[BilocationReport]    Script Date: 2024-04-07 14:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 CREATE VIEW [dbo].[BilocationReport] as 

with UsersExercises as  (
SELECT o.user_id as user_id, 'k' as typ,
       cast(m.date as date) as date_collision
FROM   orders o
       INNER JOIN coursesorders co
               ON o.order_id = co.order_id
       INNER JOIN modules m
               ON m.course_id = co.course_id  
UNION ALL
SELECT o.user_id as user_id, 's' as typ,
       cast( ss.date as date) as date_collision
FROM   orders o
       INNER JOIN studiesorders so
               ON o.order_id = so.order_id
       INNER JOIN subjects s
               ON s.studies_id = so.studies_id
       INNER JOIN subjectsschedule ss
               ON ss.subject_id = s.subject_id
			  )
			   
select user_id, date_collision, count(date_collision) as number_of_collisions from UsersExercises
group by user_id, date_collision having count(date_collision) > 1
GO
/****** Object:  View [dbo].[FutureStudiesMembers]    Script Date: 2024-04-07 14:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[FutureStudiesMembers] AS
SELECT s.studies_name,
       ISNULL(
            	(SELECT COUNT(*)
             	FROM StudiesMembers sm
             	WHERE sm.studies_id = s.studies_id
             	GROUP BY sm.studies_id),0) AS members_number,
   	mode_name,
   	MIN(c.date) AS start_date
FROM Studies s
INNER JOIN ModeDetails md ON s.mode_id = md.mode_id
INNER JOIN Subjects sb ON sb.studies_id = s.studies_id
INNER JOIN SubjectsSchedule ss ON ss.subject_id = sb.subject_id
INNER JOIN Conventions c ON c.convention_id = ss.convention_id
GROUP BY s.studies_id,
     	s.studies_name,
     	mode_name,
     	ss.convention_id
HAVING MIN(c.date) > GETDATE()
GO
/****** Object:  Table [dbo].[EntryFeePayments]    Script Date: 2024-04-07 14:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EntryFeePayments](
	[studies_id] [int] NOT NULL,
	[user_id] [int] NOT NULL,
	[payment_date] [datetime] NOT NULL,
 CONSTRAINT [EntryFeePayments_pk] PRIMARY KEY CLUSTERED 
(
	[studies_id] ASC,
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[StudiesRevenue]    Script Date: 2024-04-07 14:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create view [dbo].[StudiesRevenue] as
with temp_revenues as (
select s.studies_name, s.price * ISNULL(ep.entry_fee_count, 0) + sum(cp.paid_amount ) over (partition by s.studies_name, s.price * ISNULL(ep.entry_fee_count, 0)  ) AS total_revenue
FROM Studies s
LEFT JOIN
    (SELECT studies_id, COUNT(*) AS entry_fee_count
    FROM EntryFeePayments
    GROUP BY studies_id) ep
ON s.studies_id = ep.studies_id

inner join Subjects su on s.studies_id = su.studies_id 
inner join SubjectsSchedule ss on su.subject_id = ss.subject_id
inner join Conventions c on c.convention_id = ss.convention_id
inner join ConventionsPayments cp on cp.convention_id = c.convention_id
group by s.studies_name, s.price * ISNULL(ep.entry_fee_count, 0) , cp.paid_amount
) 
select * from temp_revenues
group by studies_name, total_revenue




GO
/****** Object:  Table [dbo].[ModulesAttendance]    Script Date: 2024-04-07 14:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ModulesAttendance](
	[module_id] [int] NOT NULL,
	[user_id] [int] NOT NULL,
	[present] [bit] NULL,
 CONSTRAINT [ModulesAttendance_pk] PRIMARY KEY CLUSTERED 
(
	[module_id] ASC,
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[ModulesAttendanceList]    Script Date: 2024-04-07 14:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[ModulesAttendanceList] AS
SELECT 
ma.module_id, 
m.domain as module_domain,
m.date, 
u.first_name, 
u.last_name, 
ma.present 
FROM ModulesAttendance ma
INNER JOIN Modules m on ma.module_id = m.module_id
INNER JOIN Users u on u.user_id = ma.user_id
GO
/****** Object:  Table [dbo].[SubjectsAttendance]    Script Date: 2024-04-07 14:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SubjectsAttendance](
	[subject_id] [int] NOT NULL,
	[user_id] [int] NOT NULL,
	[present] [bit] NULL,
 CONSTRAINT [SubjectsAttendance_pk] PRIMARY KEY CLUSTERED 
(
	[subject_id] ASC,
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[SubjectsAttendanceList]    Script Date: 2024-04-07 14:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[SubjectsAttendanceList] AS
SELECT 
convention_id, 
sa.subject_id, 
s.subject_name,
ss.date, 
u.first_name, 
u.last_name, 
sa.present 
FROM SubjectsAttendance sa
INNER JOIN SubjectsSchedule ss on ss.subject_id = sa.subject_id
inner join Subjects s on ss.subject_id = s.subject_id
INNER JOIN Users u on u.user_id = sa.user_id
;
GO
/****** Object:  UserDefinedFunction [dbo].[funcGetSubjectMembers]    Script Date: 2024-04-07 14:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[funcGetSubjectMembers] (@SubjectID int, @Date date) RETURNS TABLE AS RETURN
SELECT u.user_id,
	first_name,
   	last_name
FROM Users u
INNER JOIN StudiesMembers sm ON sm.user_id = u.user_id
INNER JOIN Studies s ON s.studies_id = sm.studies_id
INNER JOIN Subjects sub ON sub.studies_id = s.studies_id
INNER JOIN SubjectsSchedule ss ON ss.subject_id = sub.subject_id
INNER JOIN Conventions c ON c.convention_id = ss.convention_id
WHERE sub.subject_id = @SubjectID AND c.date = @Date
GO
/****** Object:  Table [dbo].[Languages]    Script Date: 2024-04-07 14:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Languages](
	[language_id] [int] NOT NULL,
	[language_name] [nvarchar](15) NOT NULL,
 CONSTRAINT [Languages_pk] PRIMARY KEY CLUSTERED 
(
	[language_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [language_nameUnique] UNIQUE NONCLUSTERED 
(
	[language_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[Schedule]    Script Date: 2024-04-07 14:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Schedule] as
select st.studies_name, s.subject_name,
cast(date as date) as date,
time, u.first_name + ' ' + u.last_name as professor, language_name as language_of_subject
from SubjectsSchedule ss
inner join Subjects s on ss.subject_id = s.subject_id
inner join Studies st on st.studies_id = s.studies_id
inner join Professors p on p.professor_id = s.professor_id
inner join Languages l on p.language_id = l.language_id
inner join Users u on u.user_id = p.user_id
;
GO
/****** Object:  UserDefinedFunction [dbo].[funcGetOrders]    Script Date: 2024-04-07 14:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[funcGetOrders] (@UserID int) RETURNS TABLE AS RETURN
SELECT w.webinar_name AS product, 
		'Webinar' AS product_type,
		w.price
From Webinars w
inner join WebinarsOrders wo on w.webinar_id = wo.webinar_id
inner join Orders o ON wo.order_id = o.order_id
inner join Users u on u.user_id = o.user_id
where u.user_id = @UserID
union
select 	c.course_name,
		'Course' AS product_type,
		c.price
From Courses c
inner join CoursesOrders co on c.course_id = co.course_id
inner join Orders o ON co.order_id = o.order_id
inner join Users u on u.user_id = o.user_id
where u.user_id = @UserID
union
select s.studies_name,
		'Studies' AS product_type,
		s.price
from Studies s
inner join StudiesOrders so on s.studies_id = so.studies_id
inner join Orders o ON so.order_id = o.order_id
inner join Users u on u.user_id = o.user_id
where u.user_id = @UserID
GO
/****** Object:  UserDefinedFunction [dbo].[funcGetModuleMembers]    Script Date: 2024-04-07 14:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[funcGetModuleMembers] (@ModuleID int, @Date varchar(16)) RETURNS TABLE AS RETURN
SELECT u.user_id,
       first_name,
       last_name
FROM Users u
INNER JOIN CourseMembers cm ON cm.user_id = u.user_id
INNER JOIN Courses c ON c.course_id = cm.course_id
INNER JOIN Modules m ON m.course_id = c.course_id
WHERE m.module_id = @ModuleID AND
      CONVERT(varchar(16), m.date, 120) >= @Date AND 
      CONVERT(varchar(16), m.date, 120) < DATEADD(MINUTE, 1, @Date);
GO
/****** Object:  Table [dbo].[Exams]    Script Date: 2024-04-07 14:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Exams](
	[exam_id] [int] NOT NULL,
	[subject_id] [int] NOT NULL,
	[date] [datetime] NOT NULL,
 CONSTRAINT [Exams_pk] PRIMARY KEY CLUSTERED 
(
	[exam_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Results]    Script Date: 2024-04-07 14:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Results](
	[user_id] [int] NOT NULL,
	[exam_id] [int] NOT NULL,
	[mark] [decimal](2, 1) NULL,
 CONSTRAINT [Results_pk] PRIMARY KEY CLUSTERED 
(
	[user_id] ASC,
	[exam_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[StudentsDiplomas]    Script Date: 2024-04-07 14:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[StudentsDiplomas] AS
SELECT u.first_name,
   	u.last_name,
   	s.studies_name,
   	sub.subject_name,
   	r.mark
FROM Users u
INNER JOIN StudiesMembers sm ON u.user_id = sm.user_id
INNER JOIN Studies s ON s.studies_id = sm.studies_id
INNER JOIN Subjects sub ON sub.studies_id = s.studies_id
INNER JOIN Exams e ON e.subject_id = sub.subject_id
inner JOIN Results r ON r.exam_id = e.exam_id and r.user_id = sm.user_id
WHERE sm.passed = 1
GO
/****** Object:  Table [dbo].[BuildingsDetails]    Script Date: 2024-04-07 14:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BuildingsDetails](
	[buidling_id] [int] NOT NULL,
	[street] [nvarchar](50) NOT NULL,
	[street_prefix] [varchar](10) NOT NULL,
	[city] [nvarchar](20) NOT NULL,
	[postal_code] [nvarchar](50) NOT NULL,
	[building_no] [varchar](10) NOT NULL,
 CONSTRAINT [BuidlingsDetails_pk] PRIMARY KEY CLUSTERED 
(
	[buidling_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DUAL]    Script Date: 2024-04-07 14:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DUAL](
	[DUMMY] [varchar](1) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EntryFeeExemption]    Script Date: 2024-04-07 14:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EntryFeeExemption](
	[user_id] [int] NOT NULL,
	[principal_id] [int] NOT NULL,
	[date] [datetime] NOT NULL,
 CONSTRAINT [EntryFeeExemption_pk] PRIMARY KEY CLUSTERED 
(
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LanguagesTranslators]    Script Date: 2024-04-07 14:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LanguagesTranslators](
	[language_id] [int] NOT NULL,
	[translator_id] [int] NOT NULL,
 CONSTRAINT [LanguagesTranslators_pk] PRIMARY KEY CLUSTERED 
(
	[language_id] ASC,
	[translator_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ModulesClassrooms]    Script Date: 2024-04-07 14:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ModulesClassrooms](
	[classroom_no] [varchar](10) NOT NULL,
	[module_id] [int] NOT NULL,
	[building_id] [int] NOT NULL,
 CONSTRAINT [ModulesClassrooms_pk] PRIMARY KEY CLUSTERED 
(
	[module_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ModulesVideos]    Script Date: 2024-04-07 14:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ModulesVideos](
	[module_id] [int] NOT NULL,
	[video_link] [nvarchar](50) NOT NULL,
 CONSTRAINT [ModulesVideos_pk] PRIMARY KEY CLUSTERED 
(
	[module_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Principals]    Script Date: 2024-04-07 14:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Principals](
	[user_id] [int] NOT NULL,
	[principal_id] [int] NOT NULL,
	[date_from] [datetime] NOT NULL,
	[date_to] [datetime] NOT NULL,
 CONSTRAINT [Principals_pk] PRIMARY KEY CLUSTERED 
(
	[principal_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Roles]    Script Date: 2024-04-07 14:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Roles](
	[role_id] [int] NOT NULL,
	[role] [nvarchar](50) NOT NULL,
 CONSTRAINT [Roles_pk] PRIMARY KEY CLUSTERED 
(
	[role_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SubjectsClassrooms]    Script Date: 2024-04-07 14:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SubjectsClassrooms](
	[subject_id] [int] NOT NULL,
	[classroom_no] [varchar](10) NOT NULL,
	[building_id] [int] NOT NULL,
 CONSTRAINT [SubjectsClassrooms_pk] PRIMARY KEY CLUSTERED 
(
	[subject_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Sylabus]    Script Date: 2024-04-07 14:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Sylabus](
	[subject_id] [int] NOT NULL,
	[domain] [nvarchar](30) NOT NULL,
	[subject_description] [nvarchar](100) NOT NULL,
 CONSTRAINT [Sylabus_pk] PRIMARY KEY CLUSTERED 
(
	[subject_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UsersRoles]    Script Date: 2024-04-07 14:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UsersRoles](
	[user_id] [int] NOT NULL,
	[role_id] [int] NOT NULL,
	[date_from] [datetime] NULL,
	[date_to] [datetime] NOT NULL,
 CONSTRAINT [UsersRoles_pk] PRIMARY KEY CLUSTERED 
(
	[user_id] ASC,
	[role_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[WebinarsPayments]    Script Date: 2024-04-07 14:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WebinarsPayments](
	[webinar_id] [int] NOT NULL,
	[user_id] [int] NOT NULL,
	[payment_date] [datetime] NOT NULL,
 CONSTRAINT [WebinarsPayments_pk] PRIMARY KEY CLUSTERED 
(
	[webinar_id] ASC,
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [index_BuildingsDetails_ID]    Script Date: 2024-04-07 14:11:19 ******/
CREATE NONCLUSTERED INDEX [index_BuildingsDetails_ID] ON [dbo].[BuildingsDetails]
(
	[buidling_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [index_Conventions_ID]    Script Date: 2024-04-07 14:11:19 ******/
CREATE NONCLUSTERED INDEX [index_Conventions_ID] ON [dbo].[Conventions]
(
	[convention_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [index_CourseMembers_userID_courseID]    Script Date: 2024-04-07 14:11:19 ******/
CREATE NONCLUSTERED INDEX [index_CourseMembers_userID_courseID] ON [dbo].[CourseMembers]
(
	[user_id] ASC,
	[course_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [index_Courses_ID_coursename]    Script Date: 2024-04-07 14:11:19 ******/
CREATE NONCLUSTERED INDEX [index_Courses_ID_coursename] ON [dbo].[Courses]
(
	[course_id] ASC,
	[course_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [index_CoursesPayments_userID_courseID]    Script Date: 2024-04-07 14:11:19 ******/
CREATE NONCLUSTERED INDEX [index_CoursesPayments_userID_courseID] ON [dbo].[CoursesPayments]
(
	[user_id] ASC,
	[course_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [index_Modules_ID_courseID]    Script Date: 2024-04-07 14:11:19 ******/
CREATE NONCLUSTERED INDEX [index_Modules_ID_courseID] ON [dbo].[Modules]
(
	[module_id] ASC,
	[course_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [index_Professors_ID_userID]    Script Date: 2024-04-07 14:11:19 ******/
CREATE NONCLUSTERED INDEX [index_Professors_ID_userID] ON [dbo].[Professors]
(
	[user_id] ASC,
	[professor_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [index_Studies_ID_studiesname]    Script Date: 2024-04-07 14:11:19 ******/
CREATE NONCLUSTERED INDEX [index_Studies_ID_studiesname] ON [dbo].[Studies]
(
	[studies_id] ASC,
	[studies_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [index_StudiesMembers_userID_studiesID]    Script Date: 2024-04-07 14:11:19 ******/
CREATE NONCLUSTERED INDEX [index_StudiesMembers_userID_studiesID] ON [dbo].[StudiesMembers]
(
	[studies_id] ASC,
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [index_Subjects_ID_subjectname_studiesid]    Script Date: 2024-04-07 14:11:19 ******/
CREATE NONCLUSTERED INDEX [index_Subjects_ID_subjectname_studiesid] ON [dbo].[Subjects]
(
	[subject_id] ASC,
	[studies_id] ASC,
	[subject_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [index_Sylabus_subjectID]    Script Date: 2024-04-07 14:11:19 ******/
CREATE NONCLUSTERED INDEX [index_Sylabus_subjectID] ON [dbo].[Sylabus]
(
	[subject_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [index_Users_ID_firstname_lastname]    Script Date: 2024-04-07 14:11:19 ******/
CREATE NONCLUSTERED INDEX [index_Users_ID_firstname_lastname] ON [dbo].[Users]
(
	[user_id] ASC,
	[first_name] ASC,
	[last_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [index_UsersAddresses_userID]    Script Date: 2024-04-07 14:11:19 ******/
CREATE NONCLUSTERED INDEX [index_UsersAddresses_userID] ON [dbo].[UsersAddresses]
(
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [index_WebinarMembers_userID_webinarID]    Script Date: 2024-04-07 14:11:19 ******/
CREATE NONCLUSTERED INDEX [index_WebinarMembers_userID_webinarID] ON [dbo].[WebinarMembers]
(
	[user_id] ASC,
	[webinar_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [index_Webinars_ID_webinarname]    Script Date: 2024-04-07 14:11:19 ******/
CREATE NONCLUSTERED INDEX [index_Webinars_ID_webinarname] ON [dbo].[Webinars]
(
	[webinar_id] ASC,
	[webinar_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ConventionsPayments] ADD  DEFAULT ((0)) FOR [paid_amount]
GO
ALTER TABLE [dbo].[CourseMembers] ADD  DEFAULT ((0)) FOR [passed]
GO
ALTER TABLE [dbo].[CoursesPayments] ADD  DEFAULT ((0)) FOR [paid_amount]
GO
ALTER TABLE [dbo].[Internships] ADD  DEFAULT ((0)) FOR [passed]
GO
ALTER TABLE [dbo].[ModulesAttendance] ADD  DEFAULT ((0)) FOR [present]
GO
ALTER TABLE [dbo].[Results] ADD  DEFAULT ((2)) FOR [mark]
GO
ALTER TABLE [dbo].[StudiesMembers] ADD  DEFAULT ((0)) FOR [passed]
GO
ALTER TABLE [dbo].[SubjectsAttendance] ADD  DEFAULT ((0)) FOR [present]
GO
ALTER TABLE [dbo].[UsersRoles] ADD  DEFAULT (getdate()) FOR [date_from]
GO
ALTER TABLE [dbo].[Cities]  WITH CHECK ADD  CONSTRAINT [Cities_Countries] FOREIGN KEY([country_id])
REFERENCES [dbo].[Countries] ([country_id])
GO
ALTER TABLE [dbo].[Cities] CHECK CONSTRAINT [Cities_Countries]
GO
ALTER TABLE [dbo].[ConventionsOrders]  WITH CHECK ADD  CONSTRAINT [ConventionsOrders_Conventions] FOREIGN KEY([convention_id])
REFERENCES [dbo].[Conventions] ([convention_id])
GO
ALTER TABLE [dbo].[ConventionsOrders] CHECK CONSTRAINT [ConventionsOrders_Conventions]
GO
ALTER TABLE [dbo].[ConventionsOrders]  WITH CHECK ADD  CONSTRAINT [ConventionsOrders_Orders] FOREIGN KEY([order_id])
REFERENCES [dbo].[Orders] ([order_id])
GO
ALTER TABLE [dbo].[ConventionsOrders] CHECK CONSTRAINT [ConventionsOrders_Orders]
GO
ALTER TABLE [dbo].[ConventionsPayments]  WITH CHECK ADD  CONSTRAINT [ConventionsPayments_Conventions] FOREIGN KEY([convention_id])
REFERENCES [dbo].[Conventions] ([convention_id])
GO
ALTER TABLE [dbo].[ConventionsPayments] CHECK CONSTRAINT [ConventionsPayments_Conventions]
GO
ALTER TABLE [dbo].[ConventionsPayments]  WITH CHECK ADD  CONSTRAINT [StudiesMembers_SubjectsPayments] FOREIGN KEY([user_id])
REFERENCES [dbo].[StudiesMembers] ([user_id])
GO
ALTER TABLE [dbo].[ConventionsPayments] CHECK CONSTRAINT [StudiesMembers_SubjectsPayments]
GO
ALTER TABLE [dbo].[CourseMembers]  WITH CHECK ADD  CONSTRAINT [Courses_CourseMembers] FOREIGN KEY([course_id])
REFERENCES [dbo].[Courses] ([course_id])
GO
ALTER TABLE [dbo].[CourseMembers] CHECK CONSTRAINT [Courses_CourseMembers]
GO
ALTER TABLE [dbo].[CourseMembers]  WITH CHECK ADD  CONSTRAINT [Users_CourseMembers] FOREIGN KEY([user_id])
REFERENCES [dbo].[Users] ([user_id])
GO
ALTER TABLE [dbo].[CourseMembers] CHECK CONSTRAINT [Users_CourseMembers]
GO
ALTER TABLE [dbo].[CoursesOrders]  WITH CHECK ADD  CONSTRAINT [CoursesOrders_Courses] FOREIGN KEY([course_id])
REFERENCES [dbo].[Courses] ([course_id])
GO
ALTER TABLE [dbo].[CoursesOrders] CHECK CONSTRAINT [CoursesOrders_Courses]
GO
ALTER TABLE [dbo].[CoursesOrders]  WITH CHECK ADD  CONSTRAINT [CoursesOrders_Orders] FOREIGN KEY([order_id])
REFERENCES [dbo].[Orders] ([order_id])
GO
ALTER TABLE [dbo].[CoursesOrders] CHECK CONSTRAINT [CoursesOrders_Orders]
GO
ALTER TABLE [dbo].[CoursesPayments]  WITH CHECK ADD  CONSTRAINT [Courses_CoursePayments] FOREIGN KEY([course_id])
REFERENCES [dbo].[Courses] ([course_id])
GO
ALTER TABLE [dbo].[CoursesPayments] CHECK CONSTRAINT [Courses_CoursePayments]
GO
ALTER TABLE [dbo].[CoursesPayments]  WITH CHECK ADD  CONSTRAINT [Users_CoursesPayments] FOREIGN KEY([user_id])
REFERENCES [dbo].[Users] ([user_id])
GO
ALTER TABLE [dbo].[CoursesPayments] CHECK CONSTRAINT [Users_CoursesPayments]
GO
ALTER TABLE [dbo].[EntryFeeExemption]  WITH CHECK ADD  CONSTRAINT [EntryFeeExemption_Users] FOREIGN KEY([user_id])
REFERENCES [dbo].[Users] ([user_id])
GO
ALTER TABLE [dbo].[EntryFeeExemption] CHECK CONSTRAINT [EntryFeeExemption_Users]
GO
ALTER TABLE [dbo].[EntryFeeExemption]  WITH CHECK ADD  CONSTRAINT [Principals_EntryFeeExemption] FOREIGN KEY([principal_id])
REFERENCES [dbo].[Principals] ([principal_id])
GO
ALTER TABLE [dbo].[EntryFeeExemption] CHECK CONSTRAINT [Principals_EntryFeeExemption]
GO
ALTER TABLE [dbo].[EntryFeePayments]  WITH CHECK ADD  CONSTRAINT [Studies_EntryFeePayments] FOREIGN KEY([studies_id])
REFERENCES [dbo].[Studies] ([studies_id])
GO
ALTER TABLE [dbo].[EntryFeePayments] CHECK CONSTRAINT [Studies_EntryFeePayments]
GO
ALTER TABLE [dbo].[EntryFeePayments]  WITH CHECK ADD  CONSTRAINT [Users_EntryFeePayments] FOREIGN KEY([user_id])
REFERENCES [dbo].[Users] ([user_id])
GO
ALTER TABLE [dbo].[EntryFeePayments] CHECK CONSTRAINT [Users_EntryFeePayments]
GO
ALTER TABLE [dbo].[Exams]  WITH CHECK ADD  CONSTRAINT [Subjects_Exams] FOREIGN KEY([subject_id])
REFERENCES [dbo].[Subjects] ([subject_id])
GO
ALTER TABLE [dbo].[Exams] CHECK CONSTRAINT [Subjects_Exams]
GO
ALTER TABLE [dbo].[Internships]  WITH CHECK ADD  CONSTRAINT [Internships_StudiesMembers] FOREIGN KEY([user_id])
REFERENCES [dbo].[StudiesMembers] ([user_id])
GO
ALTER TABLE [dbo].[Internships] CHECK CONSTRAINT [Internships_StudiesMembers]
GO
ALTER TABLE [dbo].[LanguagesTranslators]  WITH CHECK ADD  CONSTRAINT [Languages_translators_Languages] FOREIGN KEY([language_id])
REFERENCES [dbo].[Languages] ([language_id])
GO
ALTER TABLE [dbo].[LanguagesTranslators] CHECK CONSTRAINT [Languages_translators_Languages]
GO
ALTER TABLE [dbo].[LanguagesTranslators]  WITH CHECK ADD  CONSTRAINT [Translators_Languages_translators] FOREIGN KEY([translator_id])
REFERENCES [dbo].[Translators] ([translator_id])
GO
ALTER TABLE [dbo].[LanguagesTranslators] CHECK CONSTRAINT [Translators_Languages_translators]
GO
ALTER TABLE [dbo].[ModuleParticipantsLimit]  WITH CHECK ADD  CONSTRAINT [Modules_ModuleParticipantsLimit] FOREIGN KEY([module_id])
REFERENCES [dbo].[Modules] ([module_id])
GO
ALTER TABLE [dbo].[ModuleParticipantsLimit] CHECK CONSTRAINT [Modules_ModuleParticipantsLimit]
GO
ALTER TABLE [dbo].[Modules]  WITH CHECK ADD  CONSTRAINT [Modules_Courses] FOREIGN KEY([course_id])
REFERENCES [dbo].[Courses] ([course_id])
GO
ALTER TABLE [dbo].[Modules] CHECK CONSTRAINT [Modules_Courses]
GO
ALTER TABLE [dbo].[Modules]  WITH CHECK ADD  CONSTRAINT [Modules_ModeDetails] FOREIGN KEY([mode_id])
REFERENCES [dbo].[ModeDetails] ([mode_id])
GO
ALTER TABLE [dbo].[Modules] CHECK CONSTRAINT [Modules_ModeDetails]
GO
ALTER TABLE [dbo].[Modules]  WITH CHECK ADD  CONSTRAINT [Professors_Modules] FOREIGN KEY([professor_id])
REFERENCES [dbo].[Professors] ([professor_id])
GO
ALTER TABLE [dbo].[Modules] CHECK CONSTRAINT [Professors_Modules]
GO
ALTER TABLE [dbo].[ModulesAttendance]  WITH CHECK ADD  CONSTRAINT [Modules_ModulesAttendance] FOREIGN KEY([module_id])
REFERENCES [dbo].[Modules] ([module_id])
GO
ALTER TABLE [dbo].[ModulesAttendance] CHECK CONSTRAINT [Modules_ModulesAttendance]
GO
ALTER TABLE [dbo].[ModulesAttendance]  WITH CHECK ADD  CONSTRAINT [ModulesAttendance_CourseMembers] FOREIGN KEY([user_id])
REFERENCES [dbo].[CourseMembers] ([user_id])
GO
ALTER TABLE [dbo].[ModulesAttendance] CHECK CONSTRAINT [ModulesAttendance_CourseMembers]
GO
ALTER TABLE [dbo].[ModulesClassrooms]  WITH CHECK ADD  CONSTRAINT [ModulesClassrooms_BuildingsDetails] FOREIGN KEY([building_id])
REFERENCES [dbo].[BuildingsDetails] ([buidling_id])
GO
ALTER TABLE [dbo].[ModulesClassrooms] CHECK CONSTRAINT [ModulesClassrooms_BuildingsDetails]
GO
ALTER TABLE [dbo].[ModulesVideos]  WITH CHECK ADD  CONSTRAINT [Modules_ModulesVideos] FOREIGN KEY([module_id])
REFERENCES [dbo].[Modules] ([module_id])
GO
ALTER TABLE [dbo].[ModulesVideos] CHECK CONSTRAINT [Modules_ModulesVideos]
GO
ALTER TABLE [dbo].[ModuleTranslators]  WITH CHECK ADD  CONSTRAINT [ModuleTranslators_Modules] FOREIGN KEY([module_id])
REFERENCES [dbo].[Modules] ([module_id])
GO
ALTER TABLE [dbo].[ModuleTranslators] CHECK CONSTRAINT [ModuleTranslators_Modules]
GO
ALTER TABLE [dbo].[ModuleTranslators]  WITH CHECK ADD  CONSTRAINT [Translators_ModuleTranslators] FOREIGN KEY([translator_id])
REFERENCES [dbo].[Translators] ([translator_id])
GO
ALTER TABLE [dbo].[ModuleTranslators] CHECK CONSTRAINT [Translators_ModuleTranslators]
GO
ALTER TABLE [dbo].[Principals]  WITH CHECK ADD  CONSTRAINT [Users_Principals] FOREIGN KEY([user_id])
REFERENCES [dbo].[Users] ([user_id])
GO
ALTER TABLE [dbo].[Principals] CHECK CONSTRAINT [Users_Principals]
GO
ALTER TABLE [dbo].[Professors]  WITH CHECK ADD  CONSTRAINT [Professors_Languages] FOREIGN KEY([language_id])
REFERENCES [dbo].[Languages] ([language_id])
GO
ALTER TABLE [dbo].[Professors] CHECK CONSTRAINT [Professors_Languages]
GO
ALTER TABLE [dbo].[Professors]  WITH CHECK ADD  CONSTRAINT [Users_Professors] FOREIGN KEY([user_id])
REFERENCES [dbo].[Users] ([user_id])
GO
ALTER TABLE [dbo].[Professors] CHECK CONSTRAINT [Users_Professors]
GO
ALTER TABLE [dbo].[Results]  WITH CHECK ADD  CONSTRAINT [Results_Exams] FOREIGN KEY([exam_id])
REFERENCES [dbo].[Exams] ([exam_id])
GO
ALTER TABLE [dbo].[Results] CHECK CONSTRAINT [Results_Exams]
GO
ALTER TABLE [dbo].[Results]  WITH CHECK ADD  CONSTRAINT [StudiesMembers_Results] FOREIGN KEY([user_id])
REFERENCES [dbo].[StudiesMembers] ([user_id])
GO
ALTER TABLE [dbo].[Results] CHECK CONSTRAINT [StudiesMembers_Results]
GO
ALTER TABLE [dbo].[Studies]  WITH CHECK ADD  CONSTRAINT [Studies_ModeDetails] FOREIGN KEY([mode_id])
REFERENCES [dbo].[ModeDetails] ([mode_id])
GO
ALTER TABLE [dbo].[Studies] CHECK CONSTRAINT [Studies_ModeDetails]
GO
ALTER TABLE [dbo].[StudiesMembers]  WITH CHECK ADD  CONSTRAINT [StudiesMembers_Studies] FOREIGN KEY([studies_id])
REFERENCES [dbo].[Studies] ([studies_id])
GO
ALTER TABLE [dbo].[StudiesMembers] CHECK CONSTRAINT [StudiesMembers_Studies]
GO
ALTER TABLE [dbo].[StudiesMembers]  WITH CHECK ADD  CONSTRAINT [StudiesMembers_Users] FOREIGN KEY([user_id])
REFERENCES [dbo].[Users] ([user_id])
GO
ALTER TABLE [dbo].[StudiesMembers] CHECK CONSTRAINT [StudiesMembers_Users]
GO
ALTER TABLE [dbo].[StudiesOrders]  WITH CHECK ADD  CONSTRAINT [StudiesOrders_Orders] FOREIGN KEY([order_id])
REFERENCES [dbo].[Orders] ([order_id])
GO
ALTER TABLE [dbo].[StudiesOrders] CHECK CONSTRAINT [StudiesOrders_Orders]
GO
ALTER TABLE [dbo].[StudiesOrders]  WITH CHECK ADD  CONSTRAINT [StudiesOrders_Studies] FOREIGN KEY([studies_id])
REFERENCES [dbo].[Studies] ([studies_id])
GO
ALTER TABLE [dbo].[StudiesOrders] CHECK CONSTRAINT [StudiesOrders_Studies]
GO
ALTER TABLE [dbo].[Subjects]  WITH CHECK ADD  CONSTRAINT [Professors_Subjects] FOREIGN KEY([professor_id])
REFERENCES [dbo].[Professors] ([professor_id])
GO
ALTER TABLE [dbo].[Subjects] CHECK CONSTRAINT [Professors_Subjects]
GO
ALTER TABLE [dbo].[Subjects]  WITH CHECK ADD  CONSTRAINT [Subjects_Studies] FOREIGN KEY([studies_id])
REFERENCES [dbo].[Studies] ([studies_id])
GO
ALTER TABLE [dbo].[Subjects] CHECK CONSTRAINT [Subjects_Studies]
GO
ALTER TABLE [dbo].[SubjectsAttendance]  WITH CHECK ADD  CONSTRAINT [StudiesMembers_SubjectsAttendance] FOREIGN KEY([user_id])
REFERENCES [dbo].[StudiesMembers] ([user_id])
GO
ALTER TABLE [dbo].[SubjectsAttendance] CHECK CONSTRAINT [StudiesMembers_SubjectsAttendance]
GO
ALTER TABLE [dbo].[SubjectsAttendance]  WITH CHECK ADD  CONSTRAINT [SubjectsSchedule_SubjectsAttendance] FOREIGN KEY([subject_id])
REFERENCES [dbo].[SubjectsSchedule] ([subject_id])
GO
ALTER TABLE [dbo].[SubjectsAttendance] CHECK CONSTRAINT [SubjectsSchedule_SubjectsAttendance]
GO
ALTER TABLE [dbo].[SubjectsClassrooms]  WITH CHECK ADD  CONSTRAINT [Subjects_SubjectsClassroom] FOREIGN KEY([subject_id])
REFERENCES [dbo].[Subjects] ([subject_id])
GO
ALTER TABLE [dbo].[SubjectsClassrooms] CHECK CONSTRAINT [Subjects_SubjectsClassroom]
GO
ALTER TABLE [dbo].[SubjectsClassrooms]  WITH CHECK ADD  CONSTRAINT [SubjectsClassroom_BuildingsDetails] FOREIGN KEY([building_id])
REFERENCES [dbo].[BuildingsDetails] ([buidling_id])
GO
ALTER TABLE [dbo].[SubjectsClassrooms] CHECK CONSTRAINT [SubjectsClassroom_BuildingsDetails]
GO
ALTER TABLE [dbo].[SubjectsSchedule]  WITH CHECK ADD  CONSTRAINT [SubjectsSchedule_Conventions] FOREIGN KEY([convention_id])
REFERENCES [dbo].[Conventions] ([convention_id])
GO
ALTER TABLE [dbo].[SubjectsSchedule] CHECK CONSTRAINT [SubjectsSchedule_Conventions]
GO
ALTER TABLE [dbo].[SubjectsSchedule]  WITH CHECK ADD  CONSTRAINT [SubjectsSchedule_Subjects] FOREIGN KEY([subject_id])
REFERENCES [dbo].[Subjects] ([subject_id])
GO
ALTER TABLE [dbo].[SubjectsSchedule] CHECK CONSTRAINT [SubjectsSchedule_Subjects]
GO
ALTER TABLE [dbo].[SubjectTranslators]  WITH CHECK ADD  CONSTRAINT [Subjects_SubjectTranslators] FOREIGN KEY([subject_id])
REFERENCES [dbo].[Subjects] ([subject_id])
GO
ALTER TABLE [dbo].[SubjectTranslators] CHECK CONSTRAINT [Subjects_SubjectTranslators]
GO
ALTER TABLE [dbo].[SubjectTranslators]  WITH CHECK ADD  CONSTRAINT [Translators_SubjectTranslators] FOREIGN KEY([translator_id])
REFERENCES [dbo].[Translators] ([translator_id])
GO
ALTER TABLE [dbo].[SubjectTranslators] CHECK CONSTRAINT [Translators_SubjectTranslators]
GO
ALTER TABLE [dbo].[Sylabus]  WITH CHECK ADD  CONSTRAINT [Subjects_Sylabus] FOREIGN KEY([subject_id])
REFERENCES [dbo].[Subjects] ([subject_id])
GO
ALTER TABLE [dbo].[Sylabus] CHECK CONSTRAINT [Subjects_Sylabus]
GO
ALTER TABLE [dbo].[UsersAddresses]  WITH CHECK ADD  CONSTRAINT [Cities_UsersAddresses] FOREIGN KEY([city_id])
REFERENCES [dbo].[Cities] ([city_id])
GO
ALTER TABLE [dbo].[UsersAddresses] CHECK CONSTRAINT [Cities_UsersAddresses]
GO
ALTER TABLE [dbo].[UsersAddresses]  WITH CHECK ADD  CONSTRAINT [UsersAdresses_Users] FOREIGN KEY([user_id])
REFERENCES [dbo].[Users] ([user_id])
GO
ALTER TABLE [dbo].[UsersAddresses] CHECK CONSTRAINT [UsersAdresses_Users]
GO
ALTER TABLE [dbo].[UsersRoles]  WITH CHECK ADD  CONSTRAINT [Roles_UsersRoles] FOREIGN KEY([role_id])
REFERENCES [dbo].[Roles] ([role_id])
GO
ALTER TABLE [dbo].[UsersRoles] CHECK CONSTRAINT [Roles_UsersRoles]
GO
ALTER TABLE [dbo].[UsersRoles]  WITH CHECK ADD  CONSTRAINT [UsersRoles_Users] FOREIGN KEY([user_id])
REFERENCES [dbo].[Users] ([user_id])
GO
ALTER TABLE [dbo].[UsersRoles] CHECK CONSTRAINT [UsersRoles_Users]
GO
ALTER TABLE [dbo].[WebinarMembers]  WITH CHECK ADD  CONSTRAINT [Users_WebinarMembers] FOREIGN KEY([user_id])
REFERENCES [dbo].[Users] ([user_id])
GO
ALTER TABLE [dbo].[WebinarMembers] CHECK CONSTRAINT [Users_WebinarMembers]
GO
ALTER TABLE [dbo].[WebinarMembers]  WITH CHECK ADD  CONSTRAINT [WebinarMembers_Webinars] FOREIGN KEY([webinar_id])
REFERENCES [dbo].[Webinars] ([webinar_id])
GO
ALTER TABLE [dbo].[WebinarMembers] CHECK CONSTRAINT [WebinarMembers_Webinars]
GO
ALTER TABLE [dbo].[Webinars]  WITH CHECK ADD  CONSTRAINT [Webinars_Professors] FOREIGN KEY([professor_id])
REFERENCES [dbo].[Professors] ([professor_id])
GO
ALTER TABLE [dbo].[Webinars] CHECK CONSTRAINT [Webinars_Professors]
GO
ALTER TABLE [dbo].[WebinarsOrders]  WITH CHECK ADD  CONSTRAINT [WebinarsOrders_Orders] FOREIGN KEY([order_id])
REFERENCES [dbo].[Orders] ([order_id])
GO
ALTER TABLE [dbo].[WebinarsOrders] CHECK CONSTRAINT [WebinarsOrders_Orders]
GO
ALTER TABLE [dbo].[WebinarsOrders]  WITH CHECK ADD  CONSTRAINT [WebinarsOrders_Webinars] FOREIGN KEY([webinar_id])
REFERENCES [dbo].[Webinars] ([webinar_id])
GO
ALTER TABLE [dbo].[WebinarsOrders] CHECK CONSTRAINT [WebinarsOrders_Webinars]
GO
ALTER TABLE [dbo].[WebinarsPayments]  WITH CHECK ADD  CONSTRAINT [Users_WebinarsPayments] FOREIGN KEY([user_id])
REFERENCES [dbo].[Users] ([user_id])
GO
ALTER TABLE [dbo].[WebinarsPayments] CHECK CONSTRAINT [Users_WebinarsPayments]
GO
ALTER TABLE [dbo].[WebinarsPayments]  WITH CHECK ADD  CONSTRAINT [Webinars_WebinarsPayments] FOREIGN KEY([webinar_id])
REFERENCES [dbo].[Webinars] ([webinar_id])
GO
ALTER TABLE [dbo].[WebinarsPayments] CHECK CONSTRAINT [Webinars_WebinarsPayments]
GO
ALTER TABLE [dbo].[WebinarTranslators]  WITH CHECK ADD  CONSTRAINT [WebinarTranslators_Translators] FOREIGN KEY([translator_id])
REFERENCES [dbo].[Translators] ([translator_id])
GO
ALTER TABLE [dbo].[WebinarTranslators] CHECK CONSTRAINT [WebinarTranslators_Translators]
GO
ALTER TABLE [dbo].[WebinarTranslators]  WITH CHECK ADD  CONSTRAINT [WebinarTranslators_Webinars] FOREIGN KEY([webinar_id])
REFERENCES [dbo].[Webinars] ([webinar_id])
GO
ALTER TABLE [dbo].[WebinarTranslators] CHECK CONSTRAINT [WebinarTranslators_Webinars]
GO
ALTER TABLE [dbo].[Conventions]  WITH CHECK ADD  CONSTRAINT [Conventions_individual_participants_limitValid] CHECK  (([individual_participants_limit]>(0)))
GO
ALTER TABLE [dbo].[Conventions] CHECK CONSTRAINT [Conventions_individual_participants_limitValid]
GO
ALTER TABLE [dbo].[Conventions]  WITH CHECK ADD  CONSTRAINT [Conventions_priceValid] CHECK  (([price]>(0)))
GO
ALTER TABLE [dbo].[Conventions] CHECK CONSTRAINT [Conventions_priceValid]
GO
ALTER TABLE [dbo].[Conventions]  WITH CHECK ADD  CONSTRAINT [Conventions_students_priceValid] CHECK  (([students_price]>(0)))
GO
ALTER TABLE [dbo].[Conventions] CHECK CONSTRAINT [Conventions_students_priceValid]
GO
ALTER TABLE [dbo].[Courses]  WITH CHECK ADD  CONSTRAINT [Courses_dateValid] CHECK  (([end_date]>[start_date]))
GO
ALTER TABLE [dbo].[Courses] CHECK CONSTRAINT [Courses_dateValid]
GO
ALTER TABLE [dbo].[Courses]  WITH CHECK ADD  CONSTRAINT [Courses_installment_amountValid] CHECK  (([installment_amount]>(0)))
GO
ALTER TABLE [dbo].[Courses] CHECK CONSTRAINT [Courses_installment_amountValid]
GO
ALTER TABLE [dbo].[Courses]  WITH CHECK ADD  CONSTRAINT [Courses_priceValid] CHECK  (([price]>(0)))
GO
ALTER TABLE [dbo].[Courses] CHECK CONSTRAINT [Courses_priceValid]
GO
ALTER TABLE [dbo].[CoursesPayments]  WITH CHECK ADD  CONSTRAINT [CoursesPayments_paid_amountValid] CHECK  (([paid_amount]>(0)))
GO
ALTER TABLE [dbo].[CoursesPayments] CHECK CONSTRAINT [CoursesPayments_paid_amountValid]
GO
ALTER TABLE [dbo].[ModuleParticipantsLimit]  WITH CHECK ADD  CONSTRAINT [Conventions_participants_limitValid] CHECK  (([participants_limit]>(0)))
GO
ALTER TABLE [dbo].[ModuleParticipantsLimit] CHECK CONSTRAINT [Conventions_participants_limitValid]
GO
ALTER TABLE [dbo].[Principals]  WITH CHECK ADD  CONSTRAINT [Principals_datesValid] CHECK  (([date_from]<[date_to]))
GO
ALTER TABLE [dbo].[Principals] CHECK CONSTRAINT [Principals_datesValid]
GO
ALTER TABLE [dbo].[Studies]  WITH CHECK ADD  CONSTRAINT [Studies_priceValid] CHECK  (([price]>(0)))
GO
ALTER TABLE [dbo].[Studies] CHECK CONSTRAINT [Studies_priceValid]
GO
ALTER TABLE [dbo].[Users]  WITH CHECK ADD  CONSTRAINT [Users_date_of_birthValid] CHECK  (([date_of_birth]>=dateadd(year,(-100),getdate()) AND [date_of_birth]<=getdate()))
GO
ALTER TABLE [dbo].[Users] CHECK CONSTRAINT [Users_date_of_birthValid]
GO
ALTER TABLE [dbo].[Users]  WITH CHECK ADD  CONSTRAINT [Users_emailValid] CHECK  (([email] like ('%@%'+'.')+'%'))
GO
ALTER TABLE [dbo].[Users] CHECK CONSTRAINT [Users_emailValid]
GO
ALTER TABLE [dbo].[UsersRoles]  WITH CHECK ADD  CONSTRAINT [UsersRoles_datesValid] CHECK  (([date_from]<[date_to]))
GO
ALTER TABLE [dbo].[UsersRoles] CHECK CONSTRAINT [UsersRoles_datesValid]
GO
ALTER TABLE [dbo].[WebinarMembers]  WITH CHECK ADD  CONSTRAINT [WebinarMembers_datesDifferenceValid] CHECK  ((datediff(day,[access_date_from],[access_date_to])=(30)))
GO
ALTER TABLE [dbo].[WebinarMembers] CHECK CONSTRAINT [WebinarMembers_datesDifferenceValid]
GO
ALTER TABLE [dbo].[WebinarMembers]  WITH CHECK ADD  CONSTRAINT [WebinarMembers_datesValid] CHECK  (([access_date_from]<[access_date_to]))
GO
ALTER TABLE [dbo].[WebinarMembers] CHECK CONSTRAINT [WebinarMembers_datesValid]
GO
ALTER TABLE [dbo].[Webinars]  WITH CHECK ADD  CONSTRAINT [Webinars_priceValid] CHECK  (([price]>=(0)))
GO
ALTER TABLE [dbo].[Webinars] CHECK CONSTRAINT [Webinars_priceValid]
GO
/****** Object:  StoredProcedure [dbo].[AddBuilding]    Script Date: 2024-04-07 14:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 CREATE PROCEDURE [dbo].[AddBuilding] (
    @street nvarchar(50),
    @street_prefix int,
    @city nvarchar(20),
    @postal_code nvarchar(50),
    @building_no varchar(10)
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        DECLARE @building_id int;

        -- Uzyskaj nowy identyfikator budynku
        SELECT @building_id = ISNULL(MAX(buidling_id), 0) + 1 FROM BuildingsDetails;

        -- Dodaj nowy budynek do tabeli BuildingsDetails
        INSERT INTO BuildingsDetails (buidling_id, street, street_prefix, city, postal_code, building_no)
        VALUES (@building_id, @street, @street_prefix, @city, @postal_code, @building_no);

        PRINT 'Building added successfully.';
    END TRY
    BEGIN CATCH
        -- Przechwyć i rzuć dalej błąd wraz z dodatkowymi informacjami
        DECLARE @msg_error NVARCHAR(2048) = 'An error occurred while adding a building:' + CHAR(13) + CHAR(10) + ERROR_MESSAGE();
        DECLARE @error_line INT = ERROR_LINE();
        DECLARE @error_procedure NVARCHAR(128) = ERROR_PROCEDURE();
        DECLARE @msg_final NVARCHAR(2048) = @msg_error + CHAR(13) + CHAR(10) + 'Error in procedure: ' + @error_procedure + CHAR(13) + CHAR(10) + 'Error line: ' + CONVERT(NVARCHAR, @error_line);
        THROW 52000, @msg_final, 1;
    END CATCH
END;
GO
/****** Object:  StoredProcedure [dbo].[AddCity]    Script Date: 2024-04-07 14:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[AddCity] (
    @city_name nvarchar(50),
    @country_name nvarchar(50)
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        DECLARE @city_id int;
        DECLARE @country_id int;

        -- Uzyskaj identyfikator kraju na podstawie jego nazwy
        SET @country_id = (SELECT country_id FROM Countries WHERE country_name = @country_name);

        IF @country_id IS NULL
        BEGIN
            -- Jeśli kraj o podanej nazwie nie istnieje, dodaj nowy kraj
            EXEC AddCountry @country_name;
            
            -- Ponownie uzyskaj identyfikator kraju
            SET @country_id = (SELECT country_id FROM Countries WHERE country_name = @country_name);
        END

        -- Sprawdź, czy miasto o podanej nazwie już istnieje w kraju
        IF NOT EXISTS (SELECT 1 FROM Cities WHERE city_name = @city_name AND country_id = @country_id)
        BEGIN
            -- Uzyskaj nowy identyfikator miasta z sekwencji
            SELECT @city_id = ISNULL(MAX(city_id), 0) + 1 FROM Cities;

            -- Dodaj nowe miasto
            INSERT INTO Cities (city_id, city_name, country_id)
            VALUES (@city_id, @city_name, @country_id);
        END
        ELSE
        BEGIN
            -- Jeśli miasto o podanej nazwie już istnieje w kraju, nie rób nic
            RETURN;
        END
    END TRY
    BEGIN CATCH
        -- Przechwyć i rzuć dalej błąd wraz z dodatkowymi informacjami
        DECLARE @msg_1 NVARCHAR(2048) = 'An error occurred while adding a city:' + CHAR(13) + CHAR(10) + ERROR_MESSAGE();
        DECLARE @error_line INT = ERROR_LINE();
        DECLARE @error_procedure NVARCHAR(128) = ERROR_PROCEDURE();
        DECLARE @msg NVARCHAR(2048) = @msg_1 + CHAR(13) + CHAR(10) + 'Error in procedure: ' + @error_procedure + CHAR(13) + CHAR(10) + 'Error line: ' + CONVERT(NVARCHAR, @error_line);
        THROW 52000, @msg, 1;
    END CATCH
END;

GO
/****** Object:  StoredProcedure [dbo].[AddConvention]    Script Date: 2024-04-07 14:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddConvention] (
    @date date,
    @price money,
    @students_price money,
    @individual_participants_limit int
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        DECLARE @convention_id int;

        -- Uzyskaj nowy identyfikator konwencji
        SELECT @convention_id = ISNULL(MAX(convention_id), 0) + 1 FROM Conventions;

        -- Wstawienie do tabeli Conventions
        INSERT INTO Conventions (convention_id, date, price, students_price, individual_participants_limit)
        VALUES (@convention_id, @date, @price, @students_price, @individual_participants_limit);

        PRINT 'Convention added successfully.';
    END TRY
    BEGIN CATCH
        -- Przechwyć i rzuć dalej błąd wraz z dodatkowymi informacjami
        DECLARE @msg_error NVARCHAR(2048) = 'An error occurred while adding a convention:' + CHAR(13) + CHAR(10) + ERROR_MESSAGE();
        DECLARE @error_line INT = ERROR_LINE();
        DECLARE @error_procedure NVARCHAR(128) = ERROR_PROCEDURE();
        DECLARE @msg_final NVARCHAR(2048) = @msg_error + CHAR(13) + CHAR(10) + 'Error in procedure: ' + @error_procedure + CHAR(13) + CHAR(10) + 'Error line: ' + CONVERT(NVARCHAR, @error_line);
        THROW 52000, @msg_final, 1;
    END CATCH
END;
GO
/****** Object:  StoredProcedure [dbo].[AddCountry]    Script Date: 2024-04-07 14:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddCountry] (
    @country_name nvarchar(50)
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        DECLARE @country_id int;

        -- Uzyskaj nowy identyfikator kraju z sekwencji
        SELECT @country_id = ISNULL(MAX(country_id), 0) + 1 FROM Countries

        -- Sprawdź, czy kraj o podanej nazwie już istnieje
        IF NOT EXISTS (SELECT 1 FROM Countries WHERE country_name = @country_name)
        BEGIN
            -- Dodaj nowy kraj
            INSERT INTO Countries (country_id, country_name)
            VALUES (@country_id, @country_name);
        END
        ELSE
        BEGIN
            -- Jeśli kraj o podanej nazwie już istnieje, rzuć błąd
            DECLARE @msg NVARCHAR(2048) = 'A country with the name "' + @country_name + '" already exists.';
            THROW 52000, @msg, 1;
        END
    END TRY
    BEGIN CATCH
        -- Przechwyć i rzuć dalej błąd wraz z dodatkowymi informacjami
        DECLARE @msg_1 NVARCHAR(2048) = 'An error occurred while adding a country:' + CHAR(13) + CHAR(10) + ERROR_MESSAGE();
        DECLARE @error_line INT = ERROR_LINE();
        DECLARE @error_procedure NVARCHAR(128) = ERROR_PROCEDURE();
        SET @msg = @msg + CHAR(13) + CHAR(10) + 'Error in procedure: ' + @error_procedure + CHAR(13) + CHAR(10) + 'Error line: ' + CONVERT(NVARCHAR, @error_line);
        THROW 52000, @msg, 1;
    END CATCH
END;
GO
/****** Object:  StoredProcedure [dbo].[AddCourse]    Script Date: 2024-04-07 14:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[AddCourse] (
    @course_name nvarchar(255),
    @price money,
    @start_date datetime,
    @end_date datetime,
    @installment_amount money
)
AS
BEGIN

    SET NOCOUNT ON;

    BEGIN TRY

	DECLARE @course_id int;

    -- Uzyskaj nowy identyfikator kursu 
    SELECT @course_id = ISNULL(MAX(course_id), 0) + 1 FROM Courses

        -- Insert do tabeli Courses
        INSERT INTO Courses (course_id, course_name, price, start_date, end_date, installment_amount)
        VALUES (@course_id, @course_name, @price, @start_date, @end_date, @installment_amount);
    END TRY
    BEGIN CATCH
        -- Przechwyć i rzuć dalej błąd wraz z dodatkowymi informacjami
        DECLARE @msg_error NVARCHAR(2048) = 'An error occurred while adding a course:' + CHAR(13) + CHAR(10) + ERROR_MESSAGE();
        DECLARE @error_line INT = ERROR_LINE();
        DECLARE @error_procedure NVARCHAR(128) = ERROR_PROCEDURE();
        DECLARE @msg_final NVARCHAR(2048) = @msg_error + CHAR(13) + CHAR(10) + 'Error in procedure: ' + @error_procedure + CHAR(13) + CHAR(10) + 'Error line: ' + CONVERT(NVARCHAR, @error_line);
        THROW 52000, @msg_final, 1;
    END CATCH
END;
GO
/****** Object:  StoredProcedure [dbo].[AddEntryFeeExemption]    Script Date: 2024-04-07 14:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddEntryFeeExemption]
    @UserID INT,
    @PrincipalID INT
AS
BEGIN
    SET NOCOUNT ON;
 
    BEGIN TRY
    	DECLARE @CurrentDate DATETIME = GETDATE();
 
    	IF NOT EXISTS (SELECT 1 FROM Users WHERE user_id = @UserID)
    	BEGIN
        	THROW 52000, 'User with given id does not exists.', 1;
    	END;
 
    	IF NOT EXISTS (SELECT 1 FROM Principals WHERE principal_id = @PrincipalID)
    	BEGIN
        	THROW 52000, 'Principal not found.', 1;
    	END;
 
    	DECLARE @DateTo DATETIME = (SELECT date_to FROM Principals WHERE principal_id = @PrincipalID);
 
    	IF @DateTo < @CurrentDate
    	BEGIN
        	THROW 52000, 'Principal''s term has already ended.', 1;
    	END;
 
    	IF EXISTS (SELECT 1 FROM EntryFeeExemption WHERE user_id = @UserID)
    	BEGIN
        	THROW 52000, 'User already has an entry fee exemption.', 1;
    	END;
 
    	INSERT INTO EntryFeeExemption (user_id, principal_id, date)
    	VALUES (@UserID, @PrincipalID, @CurrentDate);
 
    	PRINT 'Entry fee exemption added successfully.';
    END TRY
    BEGIN CATCH
    	DECLARE @errorMsg NVARCHAR(2048) = 'An error occurred while adding entry fee exemption: ' + CHAR(13) + CHAR(10) + ERROR_MESSAGE();
    	DECLARE @errorLine INT = ERROR_LINE();
    	DECLARE @errorProcedure NVARCHAR(128) = ERROR_PROCEDURE();
    	DECLARE @errorMsgWithDetails NVARCHAR(2048) = @errorMsg + CHAR(13) + CHAR(10) + 'Error in procedure: ' + @errorProcedure + CHAR(13) + CHAR(10) + 'Error line: ' + CONVERT(NVARCHAR, @errorLine);
    	THROW 52000, @errorMsgWithDetails, 1;
    END CATCH;
END;
GO
/****** Object:  StoredProcedure [dbo].[AddInternship]    Script Date: 2024-04-07 14:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[AddInternship] (
    @first_name nvarchar(50),
    @last_name nvarchar(50),
    @start_date datetime,
    @end_date datetime,
    @passed bit = 0
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Sprawdź, czy użytkownik o podanym imieniu i nazwisku istnieje w tabeli StudiesMembers
        DECLARE @user_id int;
        SET @user_id = dbo.getUserID(@first_name, @last_name);

        IF @user_id IS NULL
        BEGIN
            DECLARE @msg_user NVARCHAR(2048) = 'User with the given name and last name does not exist in StudiesMembers.';
            THROW 52000, @msg_user, 1;
        END

        -- Dodaj nowy wpis o praktykach do tabeli Internships
        INSERT INTO Internships (user_id, start_date, end_date, passed)
        VALUES (@user_id, @start_date, @end_date, @passed);
    END TRY
    BEGIN CATCH
        -- Przechwyć i rzuć dalej błąd wraz z dodatkowymi informacjami
        DECLARE @msg_error NVARCHAR(2048) = 'An error occurred while adding an internship:' + CHAR(13) + CHAR(10) + ERROR_MESSAGE();
        DECLARE @error_line INT = ERROR_LINE();
        DECLARE @error_procedure NVARCHAR(128) = ERROR_PROCEDURE();
        DECLARE @msg_final NVARCHAR(2048) = @msg_error + CHAR(13) + CHAR(10) + 'Error in procedure: ' + @error_procedure + CHAR(13) + CHAR(10) + 'Error line: ' + CONVERT(NVARCHAR, @error_line);
        THROW 52000, @msg_final, 1;
    END CATCH
END;
GO
/****** Object:  StoredProcedure [dbo].[AddLanguage]    Script Date: 2024-04-07 14:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddLanguage] (
    @language_name nvarchar(15)
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        DECLARE @language_id int;

        -- Sprawdź, czy język o podanej nazwie już istnieje
        SELECT @language_id = language_id FROM Languages WHERE language_name = @language_name;

        IF @language_id IS NULL
        BEGIN
            -- Język nie istnieje, dodaj nowy
            SELECT @language_id = ISNULL(MAX(language_id), 0) + 1 FROM Languages;

            INSERT INTO Languages (language_id, language_name)
            VALUES (@language_id, @language_name);
        END
    END TRY
    BEGIN CATCH
        -- Przechwyć i rzuć dalej błąd wraz z dodatkowymi informacjami
        DECLARE @msg NVARCHAR(2048) = 'An error occurred while adding a language:' + CHAR(13) + CHAR(10) + ERROR_MESSAGE();
        DECLARE @error_line INT = ERROR_LINE();
        DECLARE @error_procedure NVARCHAR(128) = ERROR_PROCEDURE();
        DECLARE @msg_1 NVARCHAR(2048) = @msg + CHAR(13) + CHAR(10) + 'Error in procedure: ' + @error_procedure + CHAR(13) + CHAR(10) + 'Error line: ' + CONVERT(NVARCHAR, @error_line);
        THROW 52000, @msg_1, 1;
    END CATCH
END;
GO
/****** Object:  StoredProcedure [dbo].[AddModule]    Script Date: 2024-04-07 14:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddModule] (
    @course_name nvarchar(255),
    @professor_first_name nvarchar(50),
    @professor_last_name nvarchar(50),
    @domain nvarchar(50),
    @date datetime,
    @mode_name nvarchar(20),
    @translator_first_name nvarchar(50) = NULL,
    @translator_last_name nvarchar(50) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        DECLARE @professor_id int;
        DECLARE @translator_id int;
        DECLARE @language_id_professor int;
        DECLARE @language_id_translator int;
        DECLARE @mode_id int;
        DECLARE @module_id int;

        -- Uzyskaj nowy identyfikator modułu
        SELECT @module_id = ISNULL(MAX(module_id), 0) + 1 FROM Modules;

        -- Sprawdź, czy istnieje kurs o podanej nazwie
        IF NOT EXISTS (SELECT 1 FROM Courses WHERE course_name = @course_name)
        BEGIN
            DECLARE @msg_course NVARCHAR(2048) = 'Course with the given name does not exist.';
            THROW 52000, @msg_course, 1;
        END

        -- Uzyskaj professor_id i language_id_professor dla podanych imienia i nazwiska profesora
        SELECT @professor_id = professor_id, @language_id_professor = language_id
        FROM Professors p
        INNER JOIN Users u ON p.user_id = u.user_id
        WHERE u.first_name = @professor_first_name AND u.last_name = @professor_last_name;

        -- Sprawdź, czy udało się uzyskać poprawny professor_id
        IF @professor_id IS NOT NULL
        BEGIN
            -- Sprawdź, czy język profesora jest inny niż 'Polish'
            IF @language_id_professor <> (SELECT language_id FROM Languages WHERE language_name = 'Polish')
            BEGIN
                -- Uzyskaj translator_id dla podanych imienia i nazwiska tłumacza
                SELECT @translator_id = translator_id
                FROM Translators
                WHERE first_name = @translator_first_name AND last_name = @translator_last_name;

                -- Sprawdź, czy udało się uzyskać poprawny translator_id
                IF @translator_id IS NULL
                BEGIN
                    -- Jeśli nie udało się uzyskać translator_id, rzuć błąd
                    DECLARE @msg_translator NVARCHAR(2048) = 'Translator with the given name does not exist.';
                    THROW 52000, @msg_translator, 1;
                END

                -- Sprawdź, czy język tłumacza jest zgodny z językiem profesora
                SELECT @language_id_translator = COALESCE(t.language_id, 0)
                FROM LanguagesTranslators t
                WHERE translator_id = @translator_id;

                IF @language_id_translator <> @language_id_professor
                BEGIN
                    DECLARE @msg_language NVARCHAR(2048) = 'Translator does not translate in the same language as the professor.';
                    THROW 52000, @msg_language, 1;
                END

                -- Sprawdź zajętość tłumacza w danym czasie
                IF EXISTS (
                    SELECT 1
                    FROM TranslatorsSchedule ts
                    WHERE ts.translator_id = @translator_id
                    AND ts.date = @date
                )
                BEGIN
                    DECLARE @msg_occupied NVARCHAR(2048) = 'Translator is already occupied at the specified date and time.';
                    THROW 52000, @msg_occupied, 1;
                END
            END
            ELSE
            BEGIN
                -- Język profesora jest 'Polish', więc nie potrzebujemy tłumacza
                IF (@translator_first_name IS NOT NULL OR @translator_last_name IS NOT NULL)
                BEGIN
                    DECLARE @msg_translator_polish NVARCHAR(2048) = 'Translator is not needed as the professor speaks Polish.';
                    THROW 52000, @msg_translator_polish, 1;
                END
            END

            -- Sprawdź zajętość profesora w danym czasie
            IF EXISTS (
                SELECT 1
                FROM ProfessorsSchedule ps
                WHERE ps.professor_id = @professor_id
                AND ps.date = @date
            )
            BEGIN
                DECLARE @msg_professor_occupied NVARCHAR(2048) = 'Professor is already occupied at the specified date and time.';
                THROW 52000, @msg_professor_occupied, 1;
            END

            -- Uzyskaj mode_id dla podanego mode_name
            SELECT @mode_id = mode_id FROM ModeDetails WHERE mode_name = @mode_name;

            -- Sprawdź, czy udało się uzyskać poprawny mode_id
            IF @mode_id IS NULL
            BEGIN
                -- Jeśli nie udało się uzyskać mode_id, rzuć błąd
                DECLARE @msg_mode NVARCHAR(2048) = 'Mode with the given name does not exist.';
                THROW 52000, @msg_mode, 1;
            END

            -- Insert do tabeli Modules
            INSERT INTO Modules (module_id, course_id, professor_id, domain, date, mode_id)
            VALUES (@module_id, (SELECT course_id FROM Courses WHERE course_name = @course_name), @professor_id, @domain, @date, @mode_id);

            -- Jeżeli język profesora jest inny niż 'Polish', dodaj wpis do tabeli ModuleTranslators
            IF @language_id_professor <> (SELECT language_id FROM Languages WHERE language_name = 'Polish')
            BEGIN
                INSERT INTO ModuleTranslators (module_id, translator_id)
                VALUES (@module_id, @translator_id);
            END
        END
        ELSE
        BEGIN
            -- Jeśli nie udało się uzyskać professor_id, rzuć błąd
            DECLARE @msg_professor NVARCHAR(2048) = 'Professor with the given name does not exist.';
            THROW 52000, @msg_professor, 1;
        END
    END TRY
    BEGIN CATCH
        -- Przechwyć i rzuć dalej błąd wraz z dodatkowymi informacjami
        DECLARE @msg_error NVARCHAR(2048) = 'An error occurred while adding a module:' + CHAR(13) + CHAR(10) + ERROR_MESSAGE();
        DECLARE @error_line INT = ERROR_LINE();
        DECLARE @error_procedure NVARCHAR(128) = ERROR_PROCEDURE();
        DECLARE @msg_final NVARCHAR(2048) = @msg_error + CHAR(13) + CHAR(10) + 'Error in procedure: ' + @error_procedure + CHAR(13) + CHAR(10) + 'Error line: ' + CONVERT(NVARCHAR, @error_line);
        THROW 52000, @msg_final, 1;
    END CATCH;
END;
GO
/****** Object:  StoredProcedure [dbo].[AddOrder]    Script Date: 2024-04-07 14:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddOrder]
    @UserID INT,
    @ProductID INT,
    @ProductType NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Sprawdź poprawność ProductType
        IF NOT EXISTS (
            SELECT 1
            FROM (
                VALUES ('Webinar'), ('Course'), ('Studies'), ('Convention')
            ) AS ValidProductTypes(ProductType)
            WHERE ValidProductTypes.ProductType = @ProductType
        )
        BEGIN
            -- Rzuć błąd w przypadku niepoprawnego ProductType
            DECLARE @msg_invalid_type NVARCHAR(2048) = 'Invalid ProductType. Valid types are: Webinar, Course, Studies, Convention.';
            THROW 52001, @msg_invalid_type, 1;
        END

        -- Sprawdź, czy użytkownik nie zamówił już danego produktu
        IF EXISTS (
            SELECT 1
            FROM Orders o
            WHERE o.user_id = @UserID
              AND EXISTS (
                  SELECT 1
                  FROM WebinarsOrders wo
                  WHERE wo.order_id = o.order_id AND wo.webinar_id = @ProductID
                  AND @ProductType = 'Webinar'
              )
              OR EXISTS (
                  SELECT 1
                  FROM CoursesOrders co
                  WHERE co.order_id = o.order_id AND co.course_id = @ProductID
                  AND @ProductType = 'Course'
              )
              OR EXISTS (
                  SELECT 1
                  FROM StudiesOrders so
                  WHERE so.order_id = o.order_id AND so.studies_id = @ProductID
                  AND @ProductType = 'Studies'
              )
              OR EXISTS (
                  SELECT 1
                  FROM ConventionsOrders co
                  WHERE co.order_id = o.order_id AND co.convention_id = @ProductID
                  AND @ProductType = 'Convention'
              )
        )
        BEGIN
            DECLARE @msg_duplicate_order NVARCHAR(2048) = 'User has already ordered this product.';
            THROW 52007, @msg_duplicate_order, 1;
        END

        -- Dodaj dodatkowe warunki dla zapisów na wydarzenia
        DECLARE @msg_already_registered NVARCHAR(2048);

        IF @ProductType = 'Webinar'
        BEGIN
            IF NOT EXISTS (SELECT 1 FROM Webinars WHERE webinar_id = @ProductID)
            BEGIN
                SET @msg_already_registered = 'Webinar with the given ID is not available.';
                THROW 52002, @msg_already_registered, 1;
            END

            -- Sprawdź, czy użytkownik nie jest już zapisany na webinar
            IF EXISTS (SELECT 1 FROM WebinarMembers WHERE user_id = @UserID AND webinar_id = @ProductID)
            BEGIN
                SET @msg_already_registered = 'User is already registered for this webinar.';
                THROW 52008, @msg_already_registered, 1;
            END
        END
        ELSE IF @ProductType = 'Course'
        BEGIN
            IF NOT EXISTS (SELECT 1 FROM AvailableCourses WHERE course_id = @ProductID)
            BEGIN
                SET @msg_already_registered = 'Course with the given ID is not available.';
                THROW 52003, @msg_already_registered, 1;
            END

            -- Sprawdź, czy użytkownik nie jest już zapisany na kurs
            IF EXISTS (SELECT 1 FROM CourseMembers WHERE user_id = @UserID AND course_id = @ProductID)
            BEGIN
                SET @msg_already_registered = 'User is already registered for this course.';
                THROW 52008, @msg_already_registered, 1;
            END
        END
        ELSE IF @ProductType = 'Studies'
        BEGIN
            IF NOT EXISTS (SELECT 1 FROM AvailableStudies WHERE studies_id = @ProductID)
            BEGIN
                SET @msg_already_registered = 'Studies with the given ID are not available.';
                THROW 52004, @msg_already_registered, 1;
            END

            -- Sprawdź, czy użytkownik nie jest już zapisany na studia
            IF EXISTS (SELECT 1 FROM StudiesMembers WHERE user_id = @UserID AND studies_id = @ProductID AND is_student = 1)
            BEGIN
                SET @msg_already_registered = 'User is already registered for this studies.';
                THROW 52008, @msg_already_registered, 1;
            END
        END
        ELSE IF @ProductType = 'Convention'
        BEGIN
            IF NOT EXISTS (SELECT 1 FROM AvailableConventions WHERE convention_id = @ProductID)
            BEGIN
                SET @msg_already_registered = 'Convention with the given ID is not available.';
                THROW 52005, @msg_already_registered, 1;
            END

            -- Sprawdź, czy użytkownik nie jest już zapisany na zjazd
            IF EXISTS (SELECT 1 FROM ConventionsPayments WHERE user_id = @UserID AND convention_id = @ProductID)
            BEGIN
                SET @msg_already_registered = 'User is already registered for this convention.';
                THROW 52008, @msg_already_registered, 1;
            END
        END

        -- Ustalamy nową wartość order_id
        DECLARE @OrderID INT;
        SELECT @OrderID = ISNULL(MAX(order_id), 0) + 1 FROM Orders;

        -- Dodajemy nowe zamówienie
        INSERT INTO Orders (order_id, user_id)
        VALUES (@OrderID, @UserID);

        -- Wstawiamy zamówienie w zależności od typu produktu
        IF @ProductType = 'Webinar'
        BEGIN
            INSERT INTO WebinarsOrders (order_id, webinar_id)
            VALUES (@OrderID, @ProductID);
        END
        ELSE IF @ProductType = 'Course'
        BEGIN
            INSERT INTO CoursesOrders (order_id, course_id)
            VALUES (@OrderID, @ProductID);
        END
        ELSE IF @ProductType = 'Studies'
        BEGIN
            INSERT INTO StudiesOrders (order_id, studies_id)
            VALUES (@OrderID, @ProductID);
        END
        ELSE IF @ProductType = 'Convention'
        BEGIN
            INSERT INTO ConventionsOrders (order_id, convention_id)
            VALUES (@OrderID, @ProductID);
        END
        -- Dodaj inne warunki w razie potrzeby dla innych typów produktów

    END TRY
    BEGIN CATCH
        -- Przechwyć i rzuć dalej błąd wraz z dodatkowymi informacjami
        DECLARE @msg_error NVARCHAR(2048) = 'An error occurred while adding an order:' + CHAR(13) + CHAR(10) + ERROR_MESSAGE();
        DECLARE @error_line INT = ERROR_LINE();
        DECLARE @error_procedure NVARCHAR(128) = ERROR_PROCEDURE();
        DECLARE @msg_final NVARCHAR(2048) = @msg_error + CHAR(13) + CHAR(10) + 'Error in procedure: ' + @error_procedure + CHAR(13) + CHAR(10) + 'Error line: ' + CONVERT(NVARCHAR, @error_line);
        THROW 52000, @msg_final, 1;
    END CATCH
END;


GO
/****** Object:  StoredProcedure [dbo].[AddProfessor]    Script Date: 2024-04-07 14:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[AddProfessor] (
    @user_id int,
    @academic_title nvarchar(10),
    @language_name nvarchar(15)
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        DECLARE @professor_id int;
        DECLARE @language_id int;

        -- Uzyskaj professor_id dla nowo dodanego profesora
        SELECT @professor_id = ISNULL(MAX(professor_id), 0) + 1 FROM Professors;

        -- Uzyskaj language_id dla języka
        SELECT @language_id = COALESCE((SELECT language_id FROM Languages WHERE language_name = @language_name), 0);

        -- Sprawdź, czy udało się uzyskać poprawny language_id
        IF @language_id <> 0
        BEGIN
            -- Insert do tabeli Professors
            INSERT INTO Professors (professor_id, user_id, academic_title, language_id)
            VALUES (@professor_id, @user_id, @academic_title, @language_id);
        END
        ELSE
        BEGIN
            -- Jeśli język o podanej nazwie nie istnieje, rzuć błąd
            DECLARE @msg NVARCHAR(2048) = 'Language with the name "' + @language_name + '" does not exist.';
            THROW 52000, @msg, 1;
        END

    END TRY
    BEGIN CATCH
        -- Przechwyć i rzuć dalej błąd wraz z dodatkowymi informacjami
        DECLARE @msg_2 NVARCHAR(2048) = 'An error occurred while adding a professor:' + CHAR(13) + CHAR(10) + ERROR_MESSAGE();
        DECLARE @error_line INT = ERROR_LINE();
        DECLARE @error_procedure NVARCHAR(128) = ERROR_PROCEDURE();
        DECLARE @msg_1 NVARCHAR(2048) = @msg_2 + CHAR(13) + CHAR(10) + 'Error in procedure: ' + @error_procedure + CHAR(13) + CHAR(10) + 'Error line: ' + CONVERT(NVARCHAR, @error_line);
        THROW 52000, @msg_1, 1;
    END CATCH
END;
GO
/****** Object:  StoredProcedure [dbo].[AddResult]    Script Date: 2024-04-07 14:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddResult] (
    @first_name nvarchar(50),
    @last_name nvarchar(50),
    @subject_name nvarchar(10),
    @mark decimal(2,1) = 2
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        DECLARE @user_id int;
        DECLARE @exam_id int;

        -- Uzyskaj user_id na podstawie imienia i nazwiska
        SELECT @user_id = dbo.GetUserID(@first_name, @last_name);

        -- Uzyskaj exam_id na podstawie nazwy przedmiotu
        SELECT @exam_id = dbo.GetExamID(@subject_name);

        -- Sprawdź, czy user_id i exam_id istnieją
        IF @user_id IS NOT NULL AND @exam_id IS NOT NULL
        BEGIN
            -- Sprawdź, czy wynik dla danego użytkownika i egzaminu już istnieje
            IF NOT EXISTS (SELECT 1 FROM Results WHERE user_id = @user_id AND exam_id = @exam_id)
            BEGIN
                -- Dodaj wynik do tabeli Results
                INSERT INTO Results (user_id, exam_id, mark)
                VALUES (@user_id, @exam_id, @mark);
            END
            ELSE
            BEGIN
                -- Jeśli wynik już istnieje, rzuć błąd
                DECLARE @msg_result_exists NVARCHAR(2048) = 'Result for the given user and exam already exists.';
                THROW 52000, @msg_result_exists, 1;
            END
        END
        ELSE
        BEGIN
            -- Jeśli user_id lub exam_id nie istnieje, rzuć błąd
            DECLARE @msg_user_exam_not_found NVARCHAR(2048) = 'User or exam not found.';
            THROW 52000, @msg_user_exam_not_found, 1;
        END
    END TRY
    BEGIN CATCH
        -- Przechwyć i rzuć dalej błąd wraz z dodatkowymi informacjami
        DECLARE @msg_error NVARCHAR(2048) = 'An error occurred while adding a result:' + CHAR(13) + CHAR(10) + ERROR_MESSAGE();
        DECLARE @error_line INT = ERROR_LINE();
        DECLARE @error_procedure NVARCHAR(128) = ERROR_PROCEDURE();
        DECLARE @msg_final NVARCHAR(2048) = @msg_error + CHAR(13) + CHAR(10) + 'Error in procedure: ' + @error_procedure + CHAR(13) + CHAR(10) + 'Error line: ' + CONVERT(NVARCHAR, @error_line);
        THROW 52000, @msg_final, 1;
    END CATCH
END;
GO
/****** Object:  StoredProcedure [dbo].[AddStudy]    Script Date: 2024-04-07 14:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddStudy] (
    @studies_name nvarchar(20),
    @price money,
    @mode_id int,
    @participants_limit int
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Sprawdź, czy podany tryb istnieje w tabeli ModeDetails
        IF NOT EXISTS (SELECT 1 FROM ModeDetails WHERE mode_id = @mode_id)
        BEGIN
            DECLARE @msg_mode NVARCHAR(2048) = 'Mode with the given ID does not exist.';
            THROW 52000, @msg_mode, 1;
        END

        -- Uzyskaj nowy identyfikator studiów
        DECLARE @studies_id int;
        SELECT @studies_id = ISNULL(MAX(studies_id), 0) + 1 FROM Studies;

        -- Dodaj nowe studia do tabeli Studies
        INSERT INTO Studies (studies_id, studies_name, price, mode_id, participants_limit)
        VALUES (@studies_id, @studies_name, @price, @mode_id, @participants_limit);
    END TRY
    BEGIN CATCH
        -- Przechwyć i rzuć dalej błąd wraz z dodatkowymi informacjami
        DECLARE @msg_error NVARCHAR(2048) = 'An error occurred while adding a study:' + CHAR(13) + CHAR(10) + ERROR_MESSAGE();
        DECLARE @error_line INT = ERROR_LINE();
        DECLARE @error_procedure NVARCHAR(128) = ERROR_PROCEDURE();
        DECLARE @msg_final NVARCHAR(2048) = @msg_error + CHAR(13) + CHAR(10) + 'Error in procedure: ' + @error_procedure + CHAR(13) + CHAR(10) + 'Error line: ' + CONVERT(NVARCHAR, @error_line);
        THROW 52000, @msg_final, 1;
    END CATCH
END;
GO
/****** Object:  StoredProcedure [dbo].[AddSubject]    Script Date: 2024-04-07 14:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[AddSubject] (
    @studies_id int,
    @professor_first_name nvarchar(50),
    @professor_last_name nvarchar(50),
    @subject_name nvarchar(50),
    @week_day nvarchar(10),
    @time time(5),
    @date datetime,
    @convention_id int,
    @translator_first_name nvarchar(50) = NULL,
    @translator_last_name nvarchar(50) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        DECLARE @professor_id int;
        DECLARE @translator_id int;
        DECLARE @language_id_professor int;
        DECLARE @language_id_translator int;
        DECLARE @subject_id int;

        -- Uzyskaj nowy identyfikator przedmiotu
        SELECT @subject_id = ISNULL(MAX(subject_id), 0) + 1 FROM Subjects;

        -- Sprawdź, czy istnieje podane studies_id
        IF NOT EXISTS (SELECT 1 FROM Studies WHERE studies_id = @studies_id)
        BEGIN
            DECLARE @msg_studies NVARCHAR(2048) = 'Studies with the given ID do not exist.';
            THROW 52000, @msg_studies, 1;
        END

        -- Uzyskaj professor_id i language_id_professor dla podanych imienia i nazwiska profesora
        SELECT @professor_id = professor_id, @language_id_professor = language_id
        FROM Professors p
        INNER JOIN Users u ON p.user_id = u.user_id
        WHERE u.first_name = @professor_first_name AND u.last_name = @professor_last_name;

        -- Sprawdź, czy udało się uzyskać poprawny professor_id
        IF @professor_id IS NOT NULL
        BEGIN
            -- Sprawdź, czy język profesora jest inny niż 'Polish'
            IF @language_id_professor <> (SELECT language_id FROM Languages WHERE language_name = 'Polish')
            BEGIN
                -- Uzyskaj translator_id dla podanych imienia i nazwiska tłumacza
                SELECT @translator_id = translator_id
                FROM Translators
                WHERE first_name = @translator_first_name AND last_name = @translator_last_name;

                -- Sprawdź, czy udało się uzyskać poprawny translator_id
                IF @translator_id IS NULL
                BEGIN
                    -- Jeśli nie udało się uzyskać translator_id, rzuć błąd
                    DECLARE @msg_translator NVARCHAR(2048) = 'Translator with the given name does not exist.';
                    THROW 52000, @msg_translator, 1;
                END

                -- Sprawdź, czy język tłumacza jest zgodny z językiem profesora
                SELECT @language_id_translator = COALESCE(t.language_id, 0)
                FROM LanguagesTranslators t
                WHERE translator_id = @translator_id;

                IF @language_id_translator <> @language_id_professor
                BEGIN
                    DECLARE @msg_language NVARCHAR(2048) = 'Translator does not translate in the same language as the professor.';
                    THROW 52000, @msg_language, 1;
                END

                -- Sprawdź zajętość tłumacza w danym czasie
                IF EXISTS (
                    SELECT 1
                    FROM TranslatorsSchedule ts
                    WHERE ts.translator_id = @translator_id
                    AND ts.date = @date
                )
                BEGIN
                    DECLARE @msg_occupied NVARCHAR(2048) = 'Translator is already occupied at the specified date and time.';
                    THROW 52000, @msg_occupied, 1;
                END
            END
            ELSE
            BEGIN
                -- Język profesora jest 'Polish', więc nie potrzebujemy tłumacza
                IF (@translator_first_name IS NOT NULL OR @translator_last_name IS NOT NULL)
                BEGIN
                    DECLARE @msg_translator_polish NVARCHAR(2048) = 'Translator is not needed as the professor speaks Polish.';
                    THROW 52000, @msg_translator_polish, 1;
                END
            END

            -- Sprawdź zajętość profesora w danym dniu
            IF EXISTS (
                SELECT 1
                FROM ProfessorsSchedule ps
                WHERE ps.professor_id = @professor_id
                AND ps.date = @date
            )
            BEGIN
                DECLARE @msg_professor_occupied NVARCHAR(2048) = 'Professor is already occupied at the specified date.';
                THROW 52000, @msg_professor_occupied, 1;
            END

            -- Insert do tabeli Subjects
            INSERT INTO Subjects (subject_id, studies_id, professor_id, subject_name)
            VALUES (@subject_id, @studies_id, @professor_id, @subject_name);

            -- Insert do tabeli SubjectsSchedule
            INSERT INTO SubjectsSchedule (subject_id, week_day, time, date, convention_id)
            VALUES (@subject_id, @week_day, @time, @date, @convention_id);
        END
        ELSE
        BEGIN
            -- Jeśli nie udało się uzyskać professor_id, rzuć błąd
            DECLARE @msg_professor NVARCHAR(2048) = 'Professor with the given name does not exist.';
            THROW 52000, @msg_professor, 1;
        END
    END TRY
    BEGIN CATCH
        -- Przechwyć i rzuć dalej błąd wraz z dodatkowymi informacjami
        DECLARE @msg_error NVARCHAR(2048) = 'An error occurred while adding a subject to studies with schedule:' + CHAR(13) + CHAR(10) + ERROR_MESSAGE();
        DECLARE @error_line INT = ERROR_LINE();
        DECLARE @error_procedure NVARCHAR(128) = ERROR_PROCEDURE();
        DECLARE @msg_final NVARCHAR(2048) = @msg_error + CHAR(13) + CHAR(10) + 'Error in procedure: ' + @error_procedure + CHAR(13) + CHAR(10) + 'Error line: ' + CONVERT(NVARCHAR, @error_line);
        THROW 52000, @msg_final, 1;
    END CATCH;
END;
GO
/****** Object:  StoredProcedure [dbo].[AddTranslator]    Script Date: 2024-04-07 14:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[AddTranslator] (
    @first_name nvarchar(50),
    @last_name nvarchar(50),
    @languages nvarchar(max) -- Przekazuj listę języków oddzieloną przecinkami (np. 'English,German,French' lub '1,3,5')
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        DECLARE @translator_id int;
        DECLARE @language_identifier nvarchar(50);
        DECLARE @language_id int;
        DECLARE @languageList TABLE (language_identifier nvarchar(50));

        -- Uzyskaj nowy identyfikator tłumacza z sekwencji
        SELECT @translator_id = ISNULL(MAX(translator_id), 0) + 1 FROM Translators;

        -- Dodaj nowego tłumacza
        INSERT INTO Translators (translator_id, first_name, last_name)
        VALUES (@translator_id, @first_name, @last_name);

        -- Rozdziel listę języków i dodaj nowe języki do tabeli tymczasowej
        INSERT INTO @languageList (language_identifier)
        SELECT value FROM STRING_SPLIT(@languages, ',');

        -- Iteruj przez listę języków
        DECLARE langCursor CURSOR FOR
        SELECT language_identifier FROM @languageList;

        OPEN langCursor;
        FETCH NEXT FROM langCursor INTO @language_identifier;

        WHILE @@FETCH_STATUS = 0
        BEGIN
            -- Sprawdź, czy identyfikator to liczba całkowita
            IF ISNUMERIC(@language_identifier) = 1
            BEGIN
                SET @language_id = CAST(@language_identifier AS int);

                -- Jeżeli język nie istnieje ani po language_id, ani po language_name, dodaj go używając procedury AddLanguage
                IF NOT EXISTS (SELECT 1 FROM Languages WHERE language_id = @language_id OR language_name = @language_identifier)
                BEGIN
                    EXEC AddLanguage @language_identifier;
                END

                -- Dodaj przypisanie tłumacza do języka
                INSERT INTO LanguagesTranslators (language_id, translator_id)
                VALUES ((SELECT language_id FROM Languages WHERE language_id = @language_id OR language_name = @language_identifier), @translator_id);
            END
            ELSE
            BEGIN
                -- Sprawdź, czy język istnieje po language_name
                IF EXISTS (SELECT 1 FROM Languages WHERE language_name = @language_identifier)
                BEGIN
                    -- Jeżeli język istnieje, dodaj przypisanie tłumacza do języka
                    INSERT INTO LanguagesTranslators (language_id, translator_id)
                    VALUES ((SELECT language_id FROM Languages WHERE language_name = @language_identifier), @translator_id);
                END
                ELSE
                BEGIN
                    -- Dodaj nowy język używając procedury AddLanguage
                    EXEC AddLanguage @language_identifier;

                    -- Dodaj przypisanie tłumacza do nowego języka
                    INSERT INTO LanguagesTranslators (language_id, translator_id)
                    VALUES ((SELECT language_id FROM Languages WHERE language_name = @language_identifier), @translator_id);
                END
            END

            FETCH NEXT FROM langCursor INTO @language_identifier;
        END

        CLOSE langCursor;
        DEALLOCATE langCursor;
    END TRY
    BEGIN CATCH
        -- Przechwyć i rzuć dalej błąd wraz z dodatkowymi informacjami
        DECLARE @msg_2 NVARCHAR(2048) = 'An error occurred while adding a translator:' + CHAR(13) + CHAR(10) + ERROR_MESSAGE();
        DECLARE @error_line INT = ERROR_LINE();
        DECLARE @error_procedure NVARCHAR(128) = ERROR_PROCEDURE();
        DECLARE @msg_1 NVARCHAR(2048) = @msg_2 + CHAR(13) + CHAR(10) + 'Error in procedure: ' + @error_procedure + CHAR(13) + CHAR(10) + 'Error line: ' + CONVERT(NVARCHAR, @error_line);
        THROW 52000, @msg_1, 1;
    END CATCH
END;
GO
/****** Object:  StoredProcedure [dbo].[AddUser]    Script Date: 2024-04-07 14:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Modyfikowana procedura AddUser
CREATE PROCEDURE [dbo].[AddUser] (
    @first_name nvarchar(50),
    @last_name nvarchar(50),
    @date_of_birth date,
    @email nvarchar(50),
    @street_prefix nvarchar(3),
	@street_name nvarchar(50),
	@building_no nvarchar(10),
	@postal_code nvarchar(6),
	@city_name nvarchar(50),
	@country_name nvarchar(50),
	@role nvarchar(50),
    @academic_title nvarchar(10) = NULL,
    @language_name nvarchar(15) = NULL
)
AS
BEGIN
	SET NOCOUNT ON;
 
	BEGIN TRY
    	DECLARE @city_id int;
    	DECLARE @country_id int;
    	DECLARE @role_id int;
    	DECLARE @date_from datetime = GETDATE();
    	DECLARE @date_to datetime = '9999-12-31';
    	DECLARE @user_id int;
 
    	-- Uzyskaj user_id dla nowo dodanego użytkownika
    	SELECT @user_id = ISNULL(MAX(user_id), 0) + 1 FROM Users;
 
    	-- Insert do tabeli Users
    	INSERT INTO Users (user_id, first_name, last_name, date_of_birth, email)
    	VALUES (@user_id, @first_name, @last_name, @date_of_birth, @email);
 
    	-- Uzyskaj city_id dla miasta, jeśli nie istnieje, dodaj miasto i kraj
    	EXEC AddCity @city_name, @country_name;
    	SET @city_id = (SELECT city_id FROM Cities WHERE city_name = @city_name AND country_id = (SELECT country_id FROM Countries WHERE country_name = @country_name));
 
    	-- Sprawdź, czy rola o podanej nazwie istnieje
    	SET @role_id = (SELECT role_id FROM Roles WHERE role = @role);
 
    	IF @role_id IS NOT NULL
    	BEGIN
        	-- Insert do tabeli UsersRoles
        	INSERT INTO UsersRoles (user_id, role_id, date_from, date_to)
        	VALUES (@user_id, @role_id, @date_from, @date_to);
 
        	-- Insert do tabeli UsersAddresses
        	INSERT INTO UsersAddresses (user_id, street_prefix, street_name, building_no, postal_code, city_id)
        	VALUES (@user_id, @street_prefix, @street_name, @building_no, @postal_code, @city_id);

            -- Sprawdź, czy rola to 'Professor'
            IF @role = 'professor'
            BEGIN
                -- Dodaj profesora z uwzględnieniem warunków
                IF @academic_title IS NOT NULL AND @language_name IS NOT NULL
                BEGIN
                    DECLARE @language_id int;
                    SET @language_id = (SELECT language_id FROM Languages WHERE language_name = @language_name);
                    IF @language_id IS NOT NULL
                    BEGIN
                        -- Poprawione przekazywanie @language_name do AddProfessor
                        EXEC AddProfessor @user_id, @academic_title, @language_name;
                    END
                    ELSE
                    BEGIN
                        -- Jeśli język o podanej nazwie nie istnieje, rzuć błąd
                        DECLARE @msg_1 NVARCHAR(2048) = 'Language with the name "' + @language_name + '" does not exist.';
                        THROW 52000, @msg_1, 1;
                    END
                END
                ELSE
                BEGIN
                    -- Jeżeli brakuje wymaganych parametrów, rzuć błąd
                    DECLARE @msg NVARCHAR(2048) = 'Missing required parameters for Professor role.';
                    THROW 52000, @msg, 1;
                END
            END
    	END
    	ELSE
    	BEGIN
        	-- Jeśli rola o podanej nazwie nie istnieje, rzuć błąd
        	DECLARE @msg_4 NVARCHAR(2048) = 'Role with the name "' + @role + '" does not exist.';
        	THROW 52000, @msg_4, 1;
    	END
	END TRY
	BEGIN CATCH
    	-- Przechwyć i rzuć dalej błąd wraz z dodatkowymi informacjami
    	DECLARE @msg_2 NVARCHAR(2048) = 'An error occurred while adding a user:' + CHAR(13) + CHAR(10) + ERROR_MESSAGE();
    	DECLARE @error_line INT = ERROR_LINE();
    	DECLARE @error_procedure NVARCHAR(128) = ERROR_PROCEDURE();
    	DECLARE @msg_3 NVARCHAR(2048) = @msg_2 + CHAR(13) + CHAR(10) + 'Error in procedure: ' + @error_procedure + CHAR(13) + CHAR(10) + 'Error line: ' + CONVERT(NVARCHAR, @error_line);
    	THROW 52000, @msg_3, 1;
	END CATCH
END;
GO
/****** Object:  StoredProcedure [dbo].[AddWebinar]    Script Date: 2024-04-07 14:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddWebinar] (
    @webinar_name nvarchar(255),
    @video_link nvarchar(255),
    @price money,
    @professor_first_name nvarchar(50),
    @professor_last_name nvarchar(50),
    @webinar_date date,
    @translator_first_name nvarchar(50) = NULL,
    @translator_last_name nvarchar(50) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        DECLARE @professor_id int;
        DECLARE @translator_id int;
        DECLARE @language_id_professor int;
        DECLARE @webinar_id int;

        -- Uzyskaj professor_id i language_id_professor dla podanych imienia i nazwiska profesora
        SELECT @professor_id = professor_id, @language_id_professor = language_id
        FROM Professors p
        INNER JOIN Users u ON p.user_id = u.user_id
        WHERE u.first_name = @professor_first_name AND u.last_name = @professor_last_name;

        -- Sprawdź, czy udało się uzyskać poprawny professor_id
        IF @professor_id IS NOT NULL
        BEGIN
            -- Sprawdź, czy język profesora jest inny niż 'Polish'
            IF @language_id_professor <> (SELECT language_id FROM Languages WHERE language_name = 'Polish')
            BEGIN
                -- Uzyskaj translator_id dla podanych imienia i nazwiska tłumacza
                SELECT @translator_id = t.translator_id
                FROM Translators t INNER JOIN LanguagesTranslators lt ON t.translator_id = lt.translator_id
                WHERE t.first_name = @translator_first_name AND t.last_name = @translator_last_name AND @language_id_professor = lt.language_id;

                -- Sprawdź, czy udało się uzyskać poprawny translator_id
                IF @translator_id IS NULL
                BEGIN
                    -- Jeśli nie udało się uzyskać translator_id, rzuć błąd
                    DECLARE @msg_translator NVARCHAR(2048) = 'Translator with the given name does not exist.';
                    THROW 52000, @msg_translator, 1;
                END

                -- Sprawdź zajętość tłumacza w danym dniu
                IF EXISTS (
                    SELECT 1
                    FROM TranslatorsSchedule ts
                    WHERE ts.translator_id = @translator_id
                    AND ts.date = @webinar_date
                )
                BEGIN
                    DECLARE @msg_translator_occupied NVARCHAR(2048) = 'Translator is already occupied at the specified date.';
                    THROW 52000, @msg_translator_occupied, 1;
                END
            END
            ELSE
            BEGIN
                -- Język profesora jest 'Polish', więc nie potrzebujemy tłumacza
                SET @translator_id = NULL;
            END

            -- Sprawdź zajętość profesora w danym dniu
            IF EXISTS (
                SELECT 1
                FROM ProfessorsSchedule ps
                WHERE ps.professor_id = @professor_id
                AND ps.date = @webinar_date
            )
            BEGIN
                DECLARE @msg_professor_occupied NVARCHAR(2048) = 'Professor is already occupied at the specified date.';
                THROW 52000, @msg_professor_occupied, 1;
            END

            -- Uzyskaj nowy identyfikator webinaru
            SELECT @webinar_id = ISNULL(MAX(webinar_id), 0) + 1 FROM Webinars;

            -- Insert do tabeli Webinars
            INSERT INTO Webinars (webinar_id, webinar_name, video_link, price, professor_id, webinar_date)
            VALUES (@webinar_id, @webinar_name, @video_link, @price, @professor_id, @webinar_date);

            -- Jeżeli język profesora jest inny niż 'Polish', dodaj wpis do tabeli WebinarTranslators
            IF @language_id_professor <> (SELECT language_id FROM Languages WHERE language_name = 'Polish')
            BEGIN
                INSERT INTO WebinarTranslators (webinar_id, translator_id)
                VALUES (@webinar_id, @translator_id);
            END
        END
        ELSE
        BEGIN
            -- Jeśli nie udało się uzyskać professor_id, rzuć błąd
            DECLARE @msg_professor NVARCHAR(2048) = 'Professor with the given name does not exist.';
            THROW 52000, @msg_professor, 1;
        END
    END TRY
    BEGIN CATCH
        -- Przechwyć i rzuć dalej błąd wraz z dodatkowymi informacjami
        DECLARE @msg_error NVARCHAR(2048) = 'An error occurred while adding a webinar:' + CHAR(13) + CHAR(10) + ERROR_MESSAGE();
        DECLARE @error_line INT = ERROR_LINE();
        DECLARE @error_procedure NVARCHAR(128) = ERROR_PROCEDURE();
        DECLARE @msg_final NVARCHAR(2048) = @msg_error + CHAR(13) + CHAR(10) + 'Error in procedure: ' + @error_procedure + CHAR(13) + CHAR(10) + 'Error line: ' + CONVERT(NVARCHAR, @error_line);
        THROW 52000, @msg_final, 1;
    END CATCH;
END;

GO
/****** Object:  StoredProcedure [dbo].[ChangeSubjectClassroomNumber]    Script Date: 2024-04-07 14:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ChangeSubjectClassroomNumber]
    @SubjectID INT,
    @NewClassroomNo VARCHAR(10)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SubjectsClassrooms WHERE subject_id = @SubjectID)
        BEGIN
            THROW 52000, 'Subject not found.', 1;
        END;

        UPDATE SubjectsClassrooms
        SET classroom_no = @NewClassroomNo
        WHERE subject_id = @SubjectID;

        IF @@ROWCOUNT > 0
        BEGIN
            PRINT 'Classroom number updated successfully.';
        END
        ELSE
        BEGIN
            THROW 52000, 'No changes made.', 1;
        END
    END TRY
    BEGIN CATCH
        DECLARE @errorMsg NVARCHAR(2048) = 'An error occurred while changing classroom number: ' + CHAR(13) + CHAR(10) + ERROR_MESSAGE();
        DECLARE @errorLine INT = ERROR_LINE();
        DECLARE @errorProcedure NVARCHAR(128) = ERROR_PROCEDURE();
        DECLARE @errorMsgWithDetails NVARCHAR(2048) = @errorMsg + CHAR(13) + CHAR(10) + 'Error in procedure: ' + @errorProcedure + CHAR(13) + CHAR(10) + 'Error line: ' + CONVERT(NVARCHAR, @errorLine);
        THROW 52000, @errorMsgWithDetails, 1;
    END CATCH;
END;

GO
/****** Object:  StoredProcedure [dbo].[MarkModuleAttendance]    Script Date: 2024-04-07 14:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MarkModuleAttendance]
    @ModuleID INT,
    @Date varchar(16),
    @FirstName NVARCHAR(50),
    @LastName NVARCHAR(50),
    @Present BIT
AS
BEGIN
    SET NOCOUNT ON;
 
    BEGIN TRY
    	IF EXISTS (SELECT 1 FROM dbo.funcGetModuleMembers(@ModuleID, @Date) WHERE first_name = @FirstName AND last_name = @LastName)
    	BEGIN
        	IF @Present IN (0, 1)
        	BEGIN
            	IF NOT EXISTS (SELECT 1 FROM ModulesAttendance ma
                           	INNER JOIN Users u ON ma.user_id = u.user_id
                           	WHERE ma.module_id = @ModuleID
                             	AND u.first_name = @FirstName
                             	AND u.last_name = @LastName)
            	BEGIN
                	INSERT INTO ModulesAttendance (module_id, user_id, present)
                	VALUES (@ModuleID, (SELECT user_id FROM Users WHERE first_name = @FirstName AND last_name = @LastName), @Present);
            	END
            	ELSE
            	BEGIN
                	THROW 52002, 'Attendance record already exists for the user on the specified date.', 1;
            	END
        	END
        	ELSE
        	BEGIN
            	THROW 52001, '@Present must have a valid value (0 or 1).', 1;
        	END
    	END
    	ELSE
    	BEGIN
        	THROW 52000, 'User is not a participant in the module.', 1;
    	END
    END TRY
    BEGIN CATCH
    	DECLARE @errorMsg NVARCHAR(2048) = 'An error occurred while marking attendance: ' + CHAR(13) + CHAR(10) + ERROR_MESSAGE();
    	DECLARE @errorLine INT = ERROR_LINE();
    	DECLARE @errorProcedure NVARCHAR(128) = ERROR_PROCEDURE();
    	DECLARE @errorMsgWithDetails NVARCHAR(2048) = @errorMsg + CHAR(13) + CHAR(10) + 'Error in procedure: ' + @errorProcedure + CHAR(13) + CHAR(10) + 'Error line: ' + CONVERT(NVARCHAR, @errorLine);
    	THROW 52000, @errorMsgWithDetails, 1;
    END CATCH
END;
GO
/****** Object:  StoredProcedure [dbo].[MarkSubjectAttendance]    Script Date: 2024-04-07 14:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MarkSubjectAttendance]
    @SubjectID INT,
    @Date DATE,
    @FirstName NVARCHAR(50),
    @LastName NVARCHAR(50),
    @Present BIT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        IF EXISTS (SELECT 1 FROM dbo.funcGetSubjectMembers(@SubjectID, @Date) WHERE first_name = @FirstName AND last_name = @LastName)
        BEGIN
            IF Cast(@present as int) IN (0, 1)
            BEGIN
                IF NOT EXISTS (SELECT 1 FROM SubjectsAttendance sa
                               INNER JOIN Users u ON sa.user_id = u.user_id
                               WHERE sa.subject_id = @SubjectID
                                 AND u.first_name = @FirstName
                                 AND u.last_name = @LastName)
                BEGIN
                    INSERT INTO SubjectsAttendance (subject_id, user_id, present)
                    VALUES (@SubjectID, (SELECT user_id FROM Users WHERE first_name = @FirstName AND last_name = @LastName), @Present);
                END
                ELSE
                BEGIN
                    THROW 52002, 'Attendance record already exists for the user on the specified date.', 1;
                END
            END
            ELSE
            BEGIN
                THROW 52001, '@Present must have a valid value (0 or 1).', 1;
            END
        END
        ELSE
        BEGIN
            THROW 52000, 'User is not a participant in the subject.', 1;
        END
    END TRY
    BEGIN CATCH
        DECLARE @errorMsg NVARCHAR(2048) = 'An error occurred while marking attendance: ' + CHAR(13) + CHAR(10) + ERROR_MESSAGE();
        DECLARE @errorLine INT = ERROR_LINE();
        DECLARE @errorProcedure NVARCHAR(128) = ERROR_PROCEDURE();
        DECLARE @errorMsgWithDetails NVARCHAR(2048) = @errorMsg + CHAR(13) + CHAR(10) + 'Error in procedure: ' + @errorProcedure + CHAR(13) + CHAR(10) + 'Error line: ' + CONVERT(NVARCHAR, @errorLine);
        THROW 52000, @errorMsgWithDetails, 1;
    END CATCH
END;

GO
/****** Object:  StoredProcedure [dbo].[UpdateConventionPrice]    Script Date: 2024-04-07 14:11:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateConventionPrice]
    @ConventionID INT,
    @NewPrice MONEY
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        DECLARE @MinAllowedDate DATE = DATEADD(DAY, 3, GETDATE());

        DECLARE @CurrentDate DATE = (SELECT date FROM Conventions WHERE convention_id = @ConventionID);

        IF @CurrentDate >= @MinAllowedDate
        BEGIN
            UPDATE Conventions
            SET price = @NewPrice
            WHERE convention_id = @ConventionID;

            IF @@ROWCOUNT = 0
            BEGIN
                THROW 52002, 'Convention not found.', 1;
            END
        END
        ELSE
        BEGIN
            THROW 52001, 'Price change is allowed at least 3 days before the planned date of the convention.', 1;
        END
    END TRY
    BEGIN CATCH
        DECLARE @errorMsg NVARCHAR(2048) = 'An error occurred while updating convention price: ' + CHAR(13) + CHAR(10) + ERROR_MESSAGE();
        DECLARE @errorLine INT = ERROR_LINE();
        DECLARE @errorProcedure NVARCHAR(128) = ERROR_PROCEDURE();
        DECLARE @errorMsgWithDetails NVARCHAR(2048) = @errorMsg + CHAR(13) + CHAR(10) + 'Error in procedure: ' + @errorProcedure + CHAR(13) + CHAR(10) + 'Error line: ' + CONVERT(NVARCHAR, @errorLine);
        THROW 52000, @errorMsgWithDetails, 1;
    END CATCH
END;
GO
USE [master]
GO
ALTER DATABASE [u_petryla] SET  READ_WRITE 
GO
