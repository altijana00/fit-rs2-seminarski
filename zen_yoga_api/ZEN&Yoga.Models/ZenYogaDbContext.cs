using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;



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
            modelBuilder.Entity<StudioSubscription>().Property(ss => ss.Id).ValueGeneratedOnAdd();
            modelBuilder.Entity<YogaType>().Property(y => y.Id).ValueGeneratedOnAdd();
            modelBuilder.Entity<UserClass>().Property(uc => uc.Id).ValueGeneratedOnAdd();
            modelBuilder.Entity<UserStudio>().Property(us => us.Id).ValueGeneratedOnAdd();
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


            modelBuilder.Entity<StudioSubscription>()
                .HasOne(ss => ss.Studio)
                .WithMany(s => s.StudioSubscriptions)
                .HasForeignKey(ss => ss.StudioId)
                .OnDelete(DeleteBehavior.Cascade);

            //unique constraint on StudioId + SubscriptionTypeId
            modelBuilder.Entity<StudioSubscription>()
                .HasIndex(ss => new { ss.StudioId, ss.SubscriptionTypeId })
                .IsUnique();

        
                


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
                .HasMany(s => s.StudioSubscriptions)
                .WithOne(ss => ss.Studio)
                .HasForeignKey(ss => ss.StudioId)
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

           

            modelBuilder.Entity<StudioSubscription>()
                .Property(ss => ss.Price)
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
                FirstName = "Test1",
                LastName = "",
                CityId = 1,
                Gender = "M",
                DateOfBirth = new DateTime(1998, 6, 13),
                Email = "test@email.com",
                PasswordHash = "",
                PasswordSalt = "",
                ProfileImageUrl = "",
                RoleId = 4


            },
            new User()
            {
                Id = 2,
                FirstName = "Test2",
                LastName = "",
                CityId = 2,
                Gender = "F",
                DateOfBirth = new DateTime(1995, 6, 3),
                Email = "test2@email.com",
                PasswordHash = "",
                PasswordSalt = "",
                ProfileImageUrl = "",
                RoleId = 4
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
        public DbSet<StudioSubscription> StudioSubscriptions { get; set; }
        public DbSet<UserClass> UserClasses { get; set; }
        public DbSet<UserStudio> UsersStudios { get; set; }
        public DbSet<YogaType> YogaTypes { get; set; }
        public DbSet<StudioGallery> StudioGalleries { get; set; }
    }
}
