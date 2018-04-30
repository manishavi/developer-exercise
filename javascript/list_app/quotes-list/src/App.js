import React, { Component } from "react";

class App extends Component {
    state = {
      quotes: [],
      currentPage: 1,
      quotesPerPage: 15,
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

  componentDidMount() {
    this.dataQuotes();
  };

  render() {
    const { quotes, currentPage, quotesPerPage } = this.state;

    const indexOfLastQuote = currentPage * quotesPerPage;
    const indexOfFirstQuote = indexOfLastQuote - quotesPerPage;
    const currentQuotes = quotes.slice(indexOfFirstQuote, indexOfLastQuote);

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

    return (
      <div>
        <div className="App">
          <h1 className="Header">Quotes</h1>
          <ul>{renderQuotes}</ul>
          <ul id="page-numbers">{renderPageNumbers}</ul>
          </div>
      </div>
    );
  }
}

export default App;
