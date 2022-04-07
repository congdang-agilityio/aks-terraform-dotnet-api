using BookStore.Data.Interfaces;
using BookStore.Data.Models;
using BookStore.Data.Repositories;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace BookStoreAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class BooksController : ControllerBase
    {
        private IBookRepository books = new BookRepository();

        [HttpGet]
        public ActionResult<IEnumerable<Book>> GetAllBooks()
        {
            return books.GetAllBooks();
        }

        [HttpGet("{id}")]
        public ActionResult<Book> GetBook(int id)
        {
            var book = books.GetBook(id);
            if (book == null)
            {
                return NotFound();
            }
            return book;
        }
    }
}
