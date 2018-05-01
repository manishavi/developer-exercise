import React, { Component } from "react";

class App extends Component {
    state = {
      quotes: [],
      currentPage: 1,
      quotesPerPage: 15,
      themeMG:'',
      searchText:'',
    }
    
    dataQuotes = () => {
      fetch("https://gist.githubusercontent.com/anonymous/8f61a8733ed7fa41c4ea/raw/1e90fd2741bb6310582e3822f59927eb535f6c73/quotes.json")
        .then(response => {
          return response.json();
        })
        .then(quotes => {
          this.setState({ quotes: quotes });
        })
        .catch(err => {
          return err;
        });
    };

  handleClick = (event) => {
    this.setState({
      currentPage: Number(event.target.id)
    });
  }

  handleClickMG = (event) => {
    this.setState({
      theme: event.target.value,
    });
  }

  handlesearchResult = (event) => {
    this.setState({
      searchText: event.target.value,
    })
  }

  handleSubmit = (event) => {
    event.preventDefault();
    this.setState({
      searchText: "",
      quotes: this.state.quotes.filter(item =>
        item.quote.includes(this.state.searchText)
      )
    });
  }

  handleReload = () => {
    this.dataQuotes();
  }

  componentDidMount() {
    this.dataQuotes();
  };

  render() {
    const { quotes, currentPage, quotesPerPage } = this.state;

    const indexOfLastQuote = currentPage * quotesPerPage;
    const indexOfFirstQuote = indexOfLastQuote - quotesPerPage;
    const gameQuotes = quotes.filter(quote => quote.theme === 'games');
    const movieQuotes = quotes.filter(quote => quote.theme === 'movies');
    const currentQuotes = this.state.theme === "games" ? gameQuotes.slice(indexOfFirstQuote, indexOfLastQuote) : this.state.theme === "movies" ? movieQuotes.slice(indexOfFirstQuote, indexOfLastQuote) : quotes.slice(indexOfFirstQuote, indexOfLastQuote);
    
    const renderQuotes = currentQuotes.map((item, i) => {
      return (
      <div key={i} className='quotes'>
          <ul className='quote'>
            <li className='quote-quote sp'> <span><b>Quote:</b></span> {item.quote} </li>
            <li className='quote-source sp'> <span><b>Source:</b></span> {item.source} </li>
            <li className='quote-context sp'> <span><b>Context:</b></span> {item.context} </li>
            <li className='quote-theme sp'> <span><b>Theme:</b></span> {item.theme} </li>
          </ul>
      </div>
    );
    });

    const pageNumbers = [];
    for (let i = 1; i <= Math.ceil(quotes.length / quotesPerPage); i++) {
      pageNumbers.push(i);
    }

    const renderPageNumbers = pageNumbers.map(number => {
      return (
        <li key={number} id={number} onClick={this.handleClick}>
          {number}
        </li>
      );
    });

    return <div>
        <div className="App">
          <h1 className="Header">Quotes</h1>
          <div>
            <form className="form" onSubmit={this.handleSubmit}>
              <input type="search" placeholder="Search" value={this.state.searchText} onChange={this.handlesearchResult} />
            </form>
            <button type="button" value="reload" onClick={this.handleReload}>
              <b>RELOAD</b>
            </button>
            <button type="button" value="games" onClick={this.handleClickMG}>
              GAME
            </button>
            <button type="button" value="" onClick={this.handleClickMG}>
              QUOTE
            </button>
            <button type="button" value="movies" onClick={this.handleClickMG}>
              MOVIE
            </button>
          </div>
          <div>
            <ul>{renderQuotes}</ul>
            <li id="page-numbers">{renderPageNumbers}</li>
          </div>
        </div>
      </div>;
  }
}

export default App;
