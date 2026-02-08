using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ZEN_Yoga.Models.Helpers;



namespace ZEN_Yoga.Models
{
    public class ZenYogaDbContext : DbContext
    {

        public ZenYogaDbContext() { }

        public ZenYogaDbContext(DbContextOptions<ZenYogaDbContext> options) : base(options)
        {
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            
            modelBuilder.Entity<User>().Property(u => u.Id).ValueGeneratedOnAdd();
            modelBuilder.Entity<Instructor>().Property(i => i.Id).ValueGeneratedNever(); // Same as User Id
            modelBuilder.Entity<Payment>().Property(p => p.Id).ValueGeneratedOnAdd();
            modelBuilder.Entity<Class>().Property(c => c.Id).ValueGeneratedOnAdd();
            modelBuilder.Entity<Role>().Property(r => r.Id).ValueGeneratedOnAdd();
            modelBuilder.Entity<Studio>().Property(s => s.Id).ValueGeneratedOnAdd();
            modelBuilder.Entity<SubscriptionType>().Property(s => s.Id).ValueGeneratedOnAdd();
            modelBuilder.Entity<YogaType>().Property(y => y.Id).ValueGeneratedOnAdd();
            modelBuilder.Entity<UserClass>().Property(uc => uc.Id).ValueGeneratedOnAdd();
            modelBuilder.Entity<StudioAnalytics>().Property(sa => sa.Id).ValueGeneratedOnAdd();
            modelBuilder.Entity<AppAnalytics>().Property(a => a.Id).ValueGeneratedOnAdd();
            modelBuilder.Entity<City>().Property(c => c.Id).ValueGeneratedOnAdd();
            modelBuilder.Entity<Notification>().Property(n => n.Id).ValueGeneratedOnAdd();
            modelBuilder.Entity<StudioGallery>().Property(sg => sg.GalleryId).ValueGeneratedOnAdd();


            

            modelBuilder.Entity<Instructor>()
                .HasOne(i => i.User)
                .WithOne(u => u.Instructor)
                .HasForeignKey<Instructor>(i => i.Id)
                .OnDelete(DeleteBehavior.Cascade);


            modelBuilder.Entity<Instructor>()
                .HasOne(i => i.Studio)
                .WithMany(s => s.StudioInstructors)
                .HasForeignKey(i => i.StudioId)
                .OnDelete(DeleteBehavior.Restrict);


            modelBuilder.Entity<Class>()
                .HasOne(c => c.Studio)
                .WithMany(s => s.StudioClasses)
                .HasForeignKey(c => c.StudioId)
                .OnDelete(DeleteBehavior.Cascade);

            modelBuilder.Entity<Class>()
                .HasOne(c => c.Instructor)
                .WithMany(i => i.InstructorClasses)
                .HasForeignKey(c => c.InstructorId)
                .OnDelete(DeleteBehavior.Cascade);

            modelBuilder.Entity<Class>()
                .HasOne(c => c.YogaType)
                .WithMany(y => y.YogaTypeClasses)
                .HasForeignKey(c => c.YogaTypeId)
                .OnDelete(DeleteBehavior.Cascade);


            modelBuilder.Entity<User>()
                .HasOne(u => u.Role)
                .WithMany(r => r.Users)
                .HasForeignKey(u => u.RoleId)
                .OnDelete(DeleteBehavior.Restrict);


            modelBuilder.Entity<User>()
                .HasOne(u => u.City)
                .WithMany(c => c.Users)
                .HasForeignKey(u => u.CityId)
                .OnDelete(DeleteBehavior.Restrict); 

            modelBuilder.Entity<Studio>()
                .HasOne(s => s.City)
                .WithMany(c => c.Studios)
                .HasForeignKey(s => s.CityId)
                .OnDelete(DeleteBehavior.Restrict);

            modelBuilder.Entity<Studio>()
                .HasMany(s => s.StudioMembers)
                .WithOne(us => us.Studio)
                .HasForeignKey(us => us.StudioId)
                .OnDelete(DeleteBehavior.Restrict);


            modelBuilder.Entity<Studio>()
                .HasMany(s => s.StudioInstructors)
                .WithOne(i => i.Studio)
                .HasForeignKey(i => i.StudioId)
                .OnDelete(DeleteBehavior.Restrict);

            modelBuilder.Entity<Studio>()
                .HasMany(s => s.StudioClasses)
                .WithOne(c => c.Studio)
                .HasForeignKey(c => c.StudioId)
                .OnDelete(DeleteBehavior.Restrict);

            modelBuilder.Entity<Studio>()
                .HasMany(s => s.StudioAnalytics)
                .WithOne(sa => sa.Studio)
                .HasForeignKey(sa => sa.StudioId)
                .OnDelete(DeleteBehavior.Restrict);

            modelBuilder.Entity<Studio>()
            .HasOne(s => s.Owner)
            .WithMany() 
            .HasForeignKey(s => s.OwnerId)
            .OnDelete(DeleteBehavior.Restrict);


            modelBuilder.Entity<UserStudio>()
                .HasOne(us => us.User)
                .WithMany(u => u.UserStudios)
                .HasForeignKey(us => us.UserId)
                .OnDelete(DeleteBehavior.Cascade);

            modelBuilder.Entity<UserStudio>()
                .HasOne(us => us.Studio)
                .WithMany(s => s.StudioMembers)
                .HasForeignKey(us => us.StudioId)
                .OnDelete(DeleteBehavior.Cascade);



            modelBuilder.Entity<UserClass>()
                .HasOne(uc => uc.User)
                .WithMany(u => u.UserClasses)
                .HasForeignKey(uc => uc.UserId)
                .OnDelete(DeleteBehavior.Cascade);

            modelBuilder.Entity<UserClass>()
                .HasOne(uc => uc.Class)
                .WithMany()
                .HasForeignKey(uc => uc.ClassId)
                .OnDelete(DeleteBehavior.Restrict);


            modelBuilder.Entity<StudioAnalytics>()
                .HasOne(sa => sa.Studio)
                .WithMany(s => s.StudioAnalytics)
                .HasForeignKey(sa => sa.StudioId)
                .OnDelete(DeleteBehavior.Cascade);


            modelBuilder.Entity<Payment>()
                .HasOne(p => p.User)
                .WithMany(u => u.UserPayments)
                .HasForeignKey(p => p.UserId)
                .OnDelete(DeleteBehavior.Cascade);

            modelBuilder.Entity<Payment>()
                .HasOne(p => p.Studio)
                .WithMany()
                .HasForeignKey(p => p.StudioId)
                .OnDelete(DeleteBehavior.Restrict);

            modelBuilder.Entity<Payment>()
                .HasOne(p => p.SubscriptionType)
                .WithMany()
                .HasForeignKey(p => p.SubscriptionTypeId)
                .OnDelete(DeleteBehavior.Restrict);

         

            modelBuilder.Entity<Payment>()
                .Property(p => p.Amount)
                .HasPrecision(18, 2); 

            modelBuilder.Entity<StudioAnalytics>()
                .Property(sa => sa.TotalRevenue)
                .HasPrecision(18, 2);

           

           

            modelBuilder.Entity<Instructor>(entity =>
            {
                entity.HasKey(e => e.Id);

                entity.HasOne(e => e.User)
                    .WithOne(u => u.Instructor)
                    .HasForeignKey<Instructor>(e => e.Id)
                    .OnDelete(DeleteBehavior.Cascade); 

                entity.HasOne(e => e.Studio)
                    .WithMany(s => s.StudioInstructors)
                    .HasForeignKey(e => e.StudioId)
                    .OnDelete(DeleteBehavior.Cascade); 
            });

           


            modelBuilder.Entity<Role>().HasData(

            new Role()
            {
                Id = 1,
                Name = "Admin",
                Description = "Administrator for the system"
            },
            new Role()
            {
                Id = 2,
                Name = "Owner",
                Description = "Owner of the yoga studio"
            },
            new Role()
            {
                Id = 3,
                Name = "Instructor",
                Description = "Yoga instructor teaching the classes"
            },
            new Role()
            {
                Id = 4,
                Name = "Participant",
                Description = "Studio members and class participants"
            }
            );

            modelBuilder.Entity<City>().HasData(
                new City { Id = 1, Name = "Sarajevo" },
                new City { Id = 2, Name = "Banja Luka" },
                new City { Id = 3, Name = "Tuzla" },
                new City { Id = 4, Name = "Zenica" },
                new City { Id = 5, Name = "Mostar" },
                new City { Id = 6, Name = "Bihać" },
                new City { Id = 7, Name = "Brčko" },
                new City { Id = 8, Name = "Prijedor" },
                new City { Id = 9, Name = "Bijeljina" },
                new City { Id = 10, Name = "Doboj" },
                new City { Id = 11, Name = "Trebinje" },
                new City { Id = 12, Name = "Goražde" },
                new City { Id = 13, Name = "Travnik" },
                new City { Id = 14, Name = "Gradačac" },
                new City { Id = 15, Name = "Cazin" },
                new City { Id = 16, Name = "Visoko" },
                new City { Id = 17, Name = "Zvornik" },
                new City { Id = 18, Name = "Bugojno" },
                new City { Id = 19, Name = "Kakanj" },
                new City { Id = 20, Name = "Konjic" },
                new City { Id = 21, Name = "Sanski Most" },
                new City { Id = 22, Name = "Lukavac" },
                new City { Id = 23, Name = "Velika Kladuša" },
                new City { Id = 24, Name = "Živinice" },
                new City { Id = 25, Name = "Gradiška" },
                new City { Id = 26, Name = "Široki Brijeg" },
                new City { Id = 27, Name = "Čapljina" },
                new City { Id = 28, Name = "Foča" },
                new City { Id = 29, Name = "Modriča" },
                new City { Id = 30, Name = "Neum" }
            );

            modelBuilder.Entity<YogaType>().HasData(

                new YogaType()
                {
                    Id = 1,
                    Name = "Hatha Yoga",
                    Description = "A gentle and slow-paced yoga practice focused on basic postures and breathing techniques, ideal for beginners."
                },
                new YogaType()
                {
                    Id = 2,
                    Name = "Vinyasa Yoga",
                    Description = "A dynamic and flowing style of yoga that synchronizes breath with movement, improving flexibility and strength."
                },
                new YogaType()
                {
                    Id = 3,
                    Name = "Yin Yoga",
                    Description = "A meditative practice that targets deep connective tissues through long-held poses, promoting relaxation and flexibility."
                }
            );


            modelBuilder.Entity<SubscriptionType>().HasData(
                
                new SubscriptionType()
                {
                    Id = 1,
                    Name = "1 Month",
                    Description = "Access for 30 days.",
                    DurationInDays = 30
                },
                new SubscriptionType()
                {
                    Id = 2,
                    Name = "3 Months",
                    Description = "Access for 90 days.",
                    DurationInDays = 90
                },
                new SubscriptionType()
                {
                    Id = 3,
                    Name = "6 Months",
                    Description = "Access for 180 days.",
                    DurationInDays = 180
                },
                new SubscriptionType()
                {
                    Id = 4,
                    Name = "1 Year",
                    Description = "Access for 365 days.",
                    DurationInDays = 365
                }

            );

            modelBuilder.Entity<User>().HasData(

            new User()
            {
                Id = 1,
                FirstName = "Aiden",
                LastName = "Morris",
                CityId = 1,
                Gender = "M",
                DateOfBirth = new DateTime(1998, 6, 13),
                Email = "owner@edu.fit.ba",
                PasswordHash = PasswordHelpers.HashPassword("test").Hash,
                PasswordSalt = PasswordHelpers.HashPassword("test").Salt,
                ProfileImageUrl = "https://zenyoga.blob.core.windows.net/user-photos/AidenMorris.jpg",
                RoleId = 2


            },
            new User()
            {
                Id = 2,
                FirstName = "Mia",
                LastName = "Lopez",
                CityId = 2,
                Gender = "F",
                DateOfBirth = new DateTime(1995, 6, 3),
                Email = "admin@edu.fit.ba",
                PasswordHash = PasswordHelpers.HashPassword("test").Hash,
                PasswordSalt = PasswordHelpers.HashPassword("test").Salt,
                ProfileImageUrl = "https://zenyoga.blob.core.windows.net/user-photos/MiaLopez.jpg",
                RoleId = 1
            },

            new User()
            {
                Id = 3,
                FirstName = "Liam",
                LastName = "Smith",
                CityId = 3,
                Gender = "M",
                DateOfBirth = new DateTime(1987, 4, 12),
                Email = "liam.smith@email.com",
                PasswordHash = PasswordHelpers.HashPassword("owner123").Hash,
                PasswordSalt = PasswordHelpers.HashPassword("owner123").Salt,
                ProfileImageUrl = "https://zenyoga.blob.core.windows.net/user-photos/LiamSmith.jpg",
                RoleId = 2
            },
                new User()
                {
                    Id = 4,
                    FirstName = "Lejla",
                    LastName = "Kovačević",
                    CityId = 4,
                    Gender = "F",
                    DateOfBirth = new DateTime(1989, 9, 25),
                    Email = "lejla.kovacevic@email.com",
                    PasswordHash = PasswordHelpers.HashPassword("owner123").Hash,
                    PasswordSalt = PasswordHelpers.HashPassword("owner123").Salt,
                    ProfileImageUrl = "",
                    RoleId = 2
                },
                new User()
                {
                    Id = 5,
                    FirstName = "Noah",
                    LastName = "Brown",
                    CityId = 5,
                    Gender = "M",
                    DateOfBirth = new DateTime(1985, 1, 8),
                    Email = "noah.brown@email.com",
                    PasswordHash = PasswordHelpers.HashPassword("owner123").Hash,
                    PasswordSalt = PasswordHelpers.HashPassword("owner123").Salt,
                    ProfileImageUrl = "https://zenyoga.blob.core.windows.net/user-photos/NoahBrown.jpg",
                    RoleId = 2
                },
                
               
                new User()
                {
                    Id = 6,
                    FirstName = "Sophia",
                    LastName = "Davis",
                    CityId = 6,
                    Gender = "F",
                    DateOfBirth = new DateTime(1992, 3, 14),
                    Email = "instructor@edu.fit.ba",
                    PasswordHash = PasswordHelpers.HashPassword("test").Hash,
                    PasswordSalt = PasswordHelpers.HashPassword("test").Salt,
                    ProfileImageUrl = "https://zenyoga.blob.core.windows.net/user-photos/SophiaDavis.jpg",
                    RoleId = 3
                },
                new User()
                {
                    Id = 7,
                    FirstName = "Jackson",
                    LastName = "Miller",
                    CityId = 7,
                    Gender = "M",
                    DateOfBirth = new DateTime(1990, 7, 19),
                    Email = "jackson.miller@email.com",
                    PasswordHash = PasswordHelpers.HashPassword("instructor123").Hash,
                    PasswordSalt = PasswordHelpers.HashPassword("instructor123").Salt,
                    ProfileImageUrl = "https://zenyoga.blob.core.windows.net/user-photos/JacksonMiller.jpg",
                    RoleId = 3
                },
                new User()
                {
                    Id = 8,
                    FirstName = "Amelia",
                    LastName = "Garcia",
                    CityId = 8,
                    Gender = "F",
                    DateOfBirth = new DateTime(1991, 11, 2),
                    Email = "amelia.garcia@email.com",
                    PasswordHash = PasswordHelpers.HashPassword("instructor123").Hash,
                    PasswordSalt = PasswordHelpers.HashPassword("instructor123").Salt,
                    ProfileImageUrl = "https://zenyoga.blob.core.windows.net/user-photos/AmeliaGarcia.jpg",
                    RoleId = 3
                },
               
                new User()
                {
                    Id = 9,
                    FirstName = "James",
                    LastName = "Martinez",
                    CityId = 9,
                    Gender = "M",
                    DateOfBirth = new DateTime(1998, 5, 5),
                    Email = "participant@edu.fit.ba",
                    PasswordHash = PasswordHelpers.HashPassword("test").Hash,
                    PasswordSalt = PasswordHelpers.HashPassword("test").Salt,
                    ProfileImageUrl = "https://zenyoga.blob.core.windows.net/user-photos/JamesMartinez.jpg",
                    RoleId = 4
                },
                new User()
                {
                    Id = 10,
                    FirstName = "Isabella",
                    LastName = "Scott",
                    CityId = 10,
                    Gender = "F",
                    DateOfBirth = new DateTime(1997, 10, 17),
                    Email = "isabella.scott@email.com",
                    PasswordHash = PasswordHelpers.HashPassword("participant123").Hash,
                    PasswordSalt = PasswordHelpers.HashPassword("participant123").Salt,
                    ProfileImageUrl = "https://zenyoga.blob.core.windows.net/user-photos/IsabellaScott.jpg",
                    RoleId = 4
                },
                new User()
                {
                    Id = 11,
                    FirstName = "Mason",
                    LastName = "Walker",
                    CityId = 11,
                    Gender = "M",
                    DateOfBirth = new DateTime(1996, 2, 28),
                    Email = "mason.walker@email.com",
                    PasswordHash = PasswordHelpers.HashPassword("participant123").Hash,
                    PasswordSalt = PasswordHelpers.HashPassword("participant123").Salt,
                    ProfileImageUrl = "https://zenyoga.blob.core.windows.net/user-photos/MasonWalker.jpg",
                    RoleId = 4
                }



            );


           

            modelBuilder.Entity<Studio>().HasData(
                 new Studio () 
                 { 
                     Id = 1, 
                     Name = "Serene Flow Yoga", 
                     Address = "123 Main St", 
                     ContactPhone = "1234567890", 
                     ContactEmail = "contact@zenyoga.com", 
                     Description = "Serene Flow Yoga is a tranquil oasis designed for relaxation, self-discovery, and holistic well-being.", 
                     ProfileImageUrl = "https://zenyoga.blob.core.windows.net/studio-photos/Studio1ProfilePhoto.jpg", 
                     OwnerId = 1, 
                     CityId = 3 
                 },
                 new Studio () 
                 { 
                     Id = 2, 
                     Name = "Tranquil Lotus Yoga", 
                     Address = "456 Oak St", 
                     ContactPhone = "2345678901", 
                     ContactEmail = "contact@lotusstudio.com", 
                     Description = "Tranquil Lotus Yoga is a sanctuary for those seeking balance, flexibility, and inner harmony.", 
                     ProfileImageUrl = "https://zenyoga.blob.core.windows.net/studio-photos/Studio2ProfilePhoto.jpg", 
                     OwnerId = 1, 
                     CityId = 3 
                 },
                 new Studio () 
                 { 
                     Id = 3, 
                     Name = "Harmony Yoga", 
                     Address = "789 Pine St", 
                     ContactPhone = "3456789012", 
                     ContactEmail = "contact@harmonyyoga.com", 
                     Description = "Harmony Yoga offers a variety of classes, from gentle restorative yoga to power flows, catering to busy city dwellers seeking balance.", 
                     ProfileImageUrl = "https://zenyoga.blob.core.windows.net/studio-photos/Studio3ProfilePhoto.jpg", 
                     OwnerId = 3, 
                     CityId = 9 
                 },
                 new Studio () 
                 { 
                     Id = 4, 
                     Name = "Sunrise Yoga Haven", 
                     Address = "101 Maple St", 
                     ContactPhone = "4567890123", 
                     ContactEmail = "contact@sunriseyoga.com", 
                     Description = "A peaceful yoga retreat overlooking the town's river, offering sunrise Vinyasa flows and meditation classes to start your day with positivity and energy.", 
                     ProfileImageUrl = "https://zenyoga.blob.core.windows.net/studio-photos/Studio4ProfilePhoto.jpg", 
                     OwnerId = 4, 
                     CityId = 6 
                 }
            );

            modelBuilder.Entity<Instructor>().HasData(
               new Instructor () 
               { 
                   Biography = "Experienced yoga instructor specializing in Hatha and Vinyasa yoga. Passionate about helping students build strength and flexibility.", 
                   Diplomas = "Certified Yoga Teacher (RYT 200)", 
                   Certificates = "Advanced Hatha Yoga Certification", 
                   Id = 6, 
                   StudioId = 1 
               },
               new Instructor () 
               { 
                   Biography = "Dedicated instructor with a background in Yin and Restorative yoga. Focuses on deep relaxation and mindfulness.", 
                   Diplomas = "RYT 500 - Yoga Alliance", 
                   Certificates = "Meditation & Breathwork Certification", 
                   Id = 7 ,
                   StudioId = 3 
               },
               new Instructor () 
               { 
                   Biography = "Energetic Vinyasa yoga teacher with experience in power yoga and flow sequences. Encourages a dynamic and engaging practice.", 
                   Diplomas = "RYT 200", 
                   Certificates = "Power Yoga Certification", 
                   Id = 8 , 
                   StudioId = 2 
               }
           );


            modelBuilder.Entity<Class>().HasData(
                 new Class () 
                 { 
                     Id = 1, 
                     Name = "Morning Flow", 
                     StartDate = new DateTime(2026, 1, 20, 8, 0, 0), 
                     EndDate = new DateTime(2026, 1, 20, 9, 0, 0), 
                     YogaTypeId = 1, 
                     StudioId = 1, 
                     InstructorId = 6, 
                     Location = "Room 1", 
                     Description = "", 
                     MaxParticipants = 20 
                 },
                 new Class () 
                 { 
                     Id = 2, 
                     Name = "Power Yoga", 
                     StartDate = new DateTime(2026, 1, 20, 10, 0, 0), 
                     EndDate = new DateTime(2026, 1, 20, 11, 0, 0), 
                     YogaTypeId = 2, 
                     StudioId = 3, 
                     InstructorId = 7, 
                     Location = "Main Hall", 
                     Description = "", 
                     MaxParticipants = 20 
                 },
                 new Class () 
                 { 
                     Id = 3, 
                     Name = "Relaxing Yin", 
                     StartDate = new DateTime(2026, 1, 20, 18, 0, 0),
                     EndDate = new DateTime(2026, 1, 20, 19, 0, 0), 
                     YogaTypeId = 3, 
                     StudioId = 3, 
                     InstructorId = 7, 
                     Location = "Room 2", 
                     Description = "", 
                     MaxParticipants = 20 
                 },
                 new Class () 
                 { 
                     Id = 4, 
                     Name = "Evening Flow", 
                     StartDate = new DateTime(2026, 1, 21, 7, 0, 0), 
                     EndDate = new DateTime(2026, 1, 21, 8, 0, 0), 
                     YogaTypeId = 1, 
                     StudioId = 2, 
                     InstructorId = 8, 
                     Location = "Room 1", 
                     Description = "", 
                     MaxParticipants = 20 
                 },
                 new Class () 
                 { 
                     Id = 5, 
                     Name = "Core Strength", 
                     StartDate = new DateTime(2026, 1, 21, 9, 30, 0), 
                     EndDate = new DateTime(2026, 1, 21, 10, 30, 0), 
                     YogaTypeId = 2, 
                     StudioId = 2, 
                     InstructorId = 8, 
                     Location = "Main Hall", 
                     Description = "", 
                     MaxParticipants = 20 
                 },
                 new Class () 
                 { 
                     Id = 6, 
                     Name = "Gentle Flow", 
                     StartDate = new DateTime(2026, 1, 21, 18, 30, 0), 
                     EndDate = new DateTime(2026, 1, 21, 19, 30, 0), 
                     YogaTypeId = 3, 
                     StudioId = 1, 
                     InstructorId = 7, 
                     Location = "Room 2", 
                     Description = "", 
                     MaxParticipants = 20 
                 },
                 new Class () 
                 { 
                     Id = 7, 
                     Name = "Dynamic Yoga", 
                     StartDate = new DateTime(2026, 1, 22, 8, 0, 0), 
                     EndDate = new DateTime(2026, 1, 22, 9, 0, 0), 
                     YogaTypeId = 1, 
                     StudioId = 3, 
                     InstructorId = 7, 
                     Location = "Room 1", 
                     Description = "", 
                     MaxParticipants = 20 
                 }
            );

            modelBuilder.Entity<UserClass>().HasData(
                 new UserClass () 
                 { 
                     Id = 1, 
                     UserId = 9, 
                     ClassId = 2, 
                     JoinedAt = new DateTime(2026, 1, 14, 10, 0, 0) 
                 },
                 new UserClass () 
                 { 
                     Id = 2, 
                     UserId = 10, 
                     ClassId = 3, 
                     JoinedAt = new DateTime(2026, 1, 14, 10, 0, 0) 
                 },
                 new UserClass () 
                 { 
                     Id = 3, 
                     UserId = 10, 
                     ClassId = 4, 
                     JoinedAt = new DateTime(2026, 1, 14, 10, 0, 0) 
                 },
                 new UserClass () 
                 { 
                     Id = 4, 
                     UserId = 11, 
                     ClassId = 3, 
                     JoinedAt = new DateTime(2026, 1, 14, 10, 0, 0) 
                 },
                 new UserClass () 
                 { 
                     Id = 5, 
                     UserId = 11, 
                     ClassId = 7, 
                     JoinedAt = new DateTime(2026, 1, 14, 10, 0, 0) 
                 }
                 
            );

            modelBuilder.Entity<StudioGallery>().HasData(
                
                new StudioGallery ()
                {
                    GalleryId = 1,
                    StudioId = 1,
                    PhotoUrl = "https://zenyoga.blob.core.windows.net/studio-photos/Studio1Gallery1.jpg"
                },
                new StudioGallery()
                {
                    GalleryId = 2,
                    StudioId = 1,
                    PhotoUrl = "https://zenyoga.blob.core.windows.net/studio-photos/Studio1Gallery2.jpg"
                },
                new StudioGallery()
                {
                    GalleryId = 3,
                    StudioId = 1,
                    PhotoUrl = "https://zenyoga.blob.core.windows.net/studio-photos/Studio1Gallery3.jpg"
                },
                new StudioGallery()
                {
                    GalleryId = 4,
                    StudioId = 1,
                    PhotoUrl = "https://zenyoga.blob.core.windows.net/studio-photos/Studio1Gallery4.jpg"
                },
                new StudioGallery()
                {
                    GalleryId = 5,
                    StudioId = 2,
                    PhotoUrl = "https://zenyoga.blob.core.windows.net/studio-photos/Studio2Gallery1.jpg"
                },
                new StudioGallery()
                {
                    GalleryId = 6,
                    StudioId = 2,
                    PhotoUrl = "https://zenyoga.blob.core.windows.net/studio-photos/Studio2Gallery2.jpg"
                },
                 new StudioGallery()
                 {
                     GalleryId = 7,
                     StudioId = 3,
                     PhotoUrl = "https://zenyoga.blob.core.windows.net/studio-photos/Studio3Gallery1.jpg"
                 },
                  new StudioGallery()
                  {
                      GalleryId = 8,
                      StudioId = 3,
                      PhotoUrl = "https://zenyoga.blob.core.windows.net/studio-photos/Studio3Gallery2.jpg"
                  },
                   new StudioGallery()
                   {
                       GalleryId = 9,
                       StudioId = 4,
                       PhotoUrl = "https://zenyoga.blob.core.windows.net/studio-photos/Studio4Gallery1.jpg"
                   },
                    new StudioGallery()
                    {
                        GalleryId = 10,
                        StudioId = 4,
                        PhotoUrl = "https://zenyoga.blob.core.windows.net/studio-photos/Studio4Gallery2.jpg"
                    },
                     new StudioGallery()
                     {
                         GalleryId = 11,
                         StudioId = 4,
                         PhotoUrl = "https://zenyoga.blob.core.windows.net/studio-photos/Studio4Gallery3.jpg"
                     }


            );

            modelBuilder.Entity<Payment>().HasData(
                new Payment()
                {
                    Id = 1,
                    UserId = 11,
                    StudioId = 3,
                    SubscriptionTypeId = 1,
                    CreatedAt = new DateTime(2026, 1, 14, 10, 0, 0),
                    PaymentDate = new DateTime(2026, 1, 14, 10, 0, 0),
                    Amount = 50,
                    Status = "processing"
                
                },
                new Payment()
                {
                    Id = 2,
                    UserId = 9,
                    StudioId = 3,
                    SubscriptionTypeId = 1,
                    CreatedAt = new DateTime(2026, 1, 14, 10, 0, 0),
                    PaymentDate = new DateTime(2026, 1, 14, 10, 0, 0),
                    Amount = 50,
                    Status = "processing"
                },
                new Payment()
                {
                    Id = 3,
                    UserId = 10,
                    StudioId = 3,
                    SubscriptionTypeId = 1,
                    CreatedAt = new DateTime(2026, 1, 14, 10, 0, 0),
                    PaymentDate = new DateTime(2026, 1, 14, 10, 0, 0),
                    Amount = 50,
                    Status = "processing"
                },
                new Payment()
                {
                    Id = 4,
                    UserId = 10,
                    StudioId = 2,
                    SubscriptionTypeId = 1,
                    CreatedAt = new DateTime(2026, 1, 14, 10, 0, 0),
                    PaymentDate = new DateTime(2026, 1, 14, 10, 0, 0),
                    Amount = 50,
                    Status = "processing"
                }
            

           );



        }

        public DbSet<User> Users { get; set; }
        public DbSet<Class> Classes { get; set; }
        public DbSet<AppAnalytics> AppAnalytics { get; set; }
        public DbSet<Instructor> Instructors { get; set; }
        public DbSet<City> Cities { get; set; }
        public DbSet<SubscriptionType> SubscriptionTypes { get; set; }
        public DbSet<Notification> Notifications { get; set; }
        public DbSet<Payment> Payments { get; set; }
        public DbSet<Role> Roles { get; set; }
        public DbSet<Studio> Studios { get; set; }
        public DbSet<StudioAnalytics> StudioAnalytics { get; set; }
        public DbSet<UserClass> UserClasses { get; set; }
        public DbSet<UserStudio> UsersStudios { get; set; }
        public DbSet<YogaType> YogaTypes { get; set; }
        public DbSet<StudioGallery> StudioGalleries { get; set; }
    }
}
