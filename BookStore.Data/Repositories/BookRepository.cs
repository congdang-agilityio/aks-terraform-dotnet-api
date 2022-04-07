using BookStore.Data.Interfaces;
using BookStore.Data.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BookStore.Data.Repositories
{
    public class BookRepository : IBookRepository
    {
        public List<Book> books = new List<Book>()
        {
            new Book {Id = 1, Title = "The Girl on the Train", Author = "Hawkins, Paula", PublicationYear = 2002, IsAvailable = true, CallNumber = "229292" },
            new Book {Id = 2, Title = "The Martian", Author = "Weir, Andy", PublicationYear = 2012, IsAvailable = true, CallNumber = "229192" },
            new Book {Id = 2, Title = "The True Love", Author = "Cong, Dang", PublicationYear = 2012, IsAvailable = true, CallNumber = "229192" },
        };
        public List<Book> GetAllBooks()
        {
            return books;
        }

        public Book GetBook(int id)
        {
            return books.FirstOrDefault(x => x.Id == id);
        }
    }
}
