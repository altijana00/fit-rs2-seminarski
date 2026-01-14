using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ZEN_Yoga.Models.Exceptions
{

    //User Exceptions
    public class UserNotFoundException : Exception
    {
        public UserNotFoundException(string message) : base (message){}
    }

    public class UserAlreadyExistsException : Exception
    {
        public UserAlreadyExistsException(string message) : base(message) { }
    }

    //Instructor Exceptions
    public class InstructorNotFoundException : Exception
    {
        public InstructorNotFoundException(string message) : base(message) { }
    }

    public class InstructorAlreadyExistsException : Exception
    {
        public InstructorAlreadyExistsException(string message) : base(message) { }
    }

    //Role Exceptions
    public class RoleNotFoundException : Exception
    {
        public RoleNotFoundException(string message) : base(message) { }
    }

    //City Exceptions
    public class CityNotFoundException : Exception
    {
        public CityNotFoundException(string message) : base(message) { }
    }

    //Studio Exceptions
    public class StudioNotFoundException : Exception
    {
        public StudioNotFoundException(string message) : base(message) { }
    }

    public class StudioAlreadyExistsException : Exception
    {
        public StudioAlreadyExistsException(string message) : base(message) { }
    }

    //Class Exceptions
    public class ClassAlreadyExistsException : Exception
    {
        public ClassAlreadyExistsException(string message) : base(message) { }
    }

    //YogaType Exceptions
    public class YogaTypeNotFoundException : Exception
    {
        public YogaTypeNotFoundException(string message) : base(message) { }
    }

    //SubscriptionType Exceptions
    public class SubscriptionTypeNotFoundException : Exception
    {
        public SubscriptionTypeNotFoundException(string message) : base(message) { }
    }
}
