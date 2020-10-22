import "./App.scss";
import React from "react";
import { ResponsiveContainer, PieChart, Pie, Cell } from "recharts";
import { DocumentNode, gql, useQuery } from "@apollo/client";

const QUERY: DocumentNode = gql`
  query contriesOccurrences {
    tweetsAnalytics {
      contriesOccurrences {
        name
        occurrencesCount
      }
    }
  }
`;

const ColumnChart = ({
  title,
  data,
}: {
  title: string;
  data: readonly object[];
}) => {
  const colors: string[] = [
    '#ffe200',
    '#ff7105'
  ]

  return (
    <div className="column">
      <ResponsiveContainer height={250}>
        <PieChart>
          <Pie
            data={data}
            dataKey="value"
            nameKey="name"
            cx="50%"
            cy="50%"
            innerRadius={60}
            outerRadius={80}
            label
          >
            {data.map((_entry, index) => (
              <Cell key={`cell-${index}`} fill={colors[index]} />
            ))}
          </Pie>
        </PieChart>
      </ResponsiveContainer>
      <span className="title">{title}</span>
    </div>
  );
};

const App = () => {
  const { data, loading, error } = useQuery(QUERY);

  if (loading) return <div></div>;
  if (error) throw error;

  const chartData = data.tweetsAnalytics.contriesOccurrences.map(
    ({
      name,
      occurrencesCount,
    }: {
      name: string;
      occurrencesCount: string;
    }) => ({ name, value: occurrencesCount }),
  );

  return (
    <div className="App">
      <div className="main">
        <header>
          <img src="favicon.ico" alt="Thrub's face"></img>
          <h2>Thrumb's charts</h2>
        </header>
        <div className="columns">
          <ColumnChart title="US vs Russia" data={chartData} />
          <ColumnChart title="Favourite child" data={chartData} />
          <ColumnChart title="Occurrencies of 'democracy' till date" data={chartData} />
        </div>
      </div>
    </div>
  );
};

export default App;
