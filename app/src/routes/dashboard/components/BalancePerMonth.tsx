import { Box, Card, CardHeader, Flex, Text } from '@chakra-ui/react';
import Loading from '@pesabooks/components/Loading';
import { ApexOptions } from 'apexcharts';
import { useEffect, useState } from 'react';
import ReactApexChart from 'react-apexcharts';

const options: ApexOptions = {
  chart: {
    toolbar: {
      show: false,
    },
  },
  tooltip: {
    theme: 'dark',
  },
  dataLabels: {
    enabled: false,
  },
  stroke: {
    curve: 'smooth',
  },
  xaxis: {
    type: 'category',
    labels: {
      style: {
        colors: '#c8cfca',
        fontSize: '12px',
      },
    },
  },
  yaxis: {
    labels: {
      style: {
        colors: '#c8cfca',
        fontSize: '12px',
      },
    },
  },
  legend: {
    show: false,
  },
  grid: {
    strokeDashArray: 5,
  },
  fill: {
    type: 'gradient',
    gradient: {
      shade: 'light',
      type: 'vertical',
      shadeIntensity: 0.5,
      gradientToColors: undefined, // optional, if not defined - uses the shades of same color in series
      inverseColors: true,
      opacityFrom: 0.8,
      opacityTo: 0,
      stops: [],
    },
    colors: ['#4FD1C5', '#2D3748'],
  },
  colors: ['#4FD1C5', '#2D3748'],
};
interface BalancesPerMonthProps {
  pool_id: string;
}

export const BalancesPerMonth = ({ pool_id }: BalancesPerMonthProps) => {
  const [series, setSeries] = useState<unknown[]>([]);
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    const fetchData = async () => {
      try {
        // const { data } = await supabase().rpc('get_balance_per_month', { pool_id });
        const data:any[] = [];

        setSeries([{ name: 'Balance', data: data?.map((d) => ({ x: d.month, y: d.balance })) }]);
      } finally {
        setIsLoading(false);
      }
    };
    fetchData();
  }, [pool_id]);

  return (
    <Card  mb={{ sm: '26px', lg: '0px' }}>
      <CardHeader >
        <Flex direction="column" alignSelf="flex-start">
          <Text fontSize="lg" fontWeight="bold" mb="6px">
            Balance
          </Text>
        </Flex>
      </CardHeader>
      <Box w="100%" h={{ sm: '300px' }} ps="8px">
        {isLoading ? (
          <Loading />
        ) : (
          <ReactApexChart
            options={options}
            series={series as any}
            type="area"
            width="100%"
            height="100%"
          />
        )}
      </Box>
    </Card>
  );
};