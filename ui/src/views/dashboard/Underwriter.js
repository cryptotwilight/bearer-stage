import React from "react";
import ChartistGraph from "react-chartist";
// react-bootstrap components
import {
  Badge,
  Button,
  Card,
  Navbar,
  Nav,
  Table,
  Container,
  Row,
  Col,
  Form,
  OverlayTrigger,
  Tooltip,
} from "react-bootstrap";

function Dashboard() {
  return (
    <>
      <Container fluid>
        <Row>
          <Col lg="3" sm="6">
            <Card className="card-stats">
              <Card.Body>
                <Row>
                  <Col xs="5">
                    <div className="icon-big text-center icon-warning">
                      <i className="nc-icon nc-money-coins text-warning"></i>
                    </div>
                  </Col>
                  <Col xs="7">
                    <div className="numbers">
                      <p className="card-category">Capital At Risk</p>
                      <Card.Title as="h4">USDC 150,000.00</Card.Title>
                    </div>
                  </Col>
                </Row>
              </Card.Body>
              <Card.Footer>
                <hr></hr>
                <div className="stats">
                  <i className="fas fa-redo mr-1"></i>
                 Refresh
                </div>
              </Card.Footer>
            </Card>
          </Col>
          <Col lg="3" sm="6">
            <Card className="card-stats">
              <Card.Body>
                <Row>
                  <Col xs="5">
                    <div className="icon-big text-center icon-warning">
                      <i className="nc-icon nc-chart-bar-32 text-success"></i>
                    </div>
                  </Col>
                  <Col xs="7">
                    <div className="numbers">
                      <p className="card-category">Inventory Underwritten </p>
                      <Card.Title as="h4">USDC 750,000.00</Card.Title>
                    </div>
                  </Col>
                </Row>
              </Card.Body>
              <Card.Footer>
                <hr></hr>
                <div className="stats">
                  <i className="far fa-calendar-alt mr-1"></i>
                  Last day
                </div>
              </Card.Footer>
            </Card>
          </Col>
          <Col lg="3" sm="6">
            <Card className="card-stats">
              <Card.Body>
                <Row>
                  <Col xs="5">
                    <div className="icon-big text-center icon-warning">
                      <i className="nc-icon nc-tag-content text-danger"></i>
                    </div>
                  </Col>
                  <Col xs="7">
                    <div className="numbers">
                      <p className="card-category">Average Emissions</p>
                      <Card.Title as="h4">10.5% (p/m)</Card.Title>
                    </div>
                  </Col>
                </Row>
              </Card.Body>
              <Card.Footer>
                <hr></hr>
                <div className="stats">
                  <i className="far fa-clock-o mr-1"></i>
                  In the last hour
                </div>
              </Card.Footer>
            </Card>
          </Col>
          <Col lg="3" sm="6">
            <Card className="card-stats">
              <Card.Body>
                <Row>
                  <Col xs="5">
                    <div className="icon-big text-center icon-warning">
                      <i className="nc-icon nc-umbrella-13 text-primary"></i>
                    </div>
                  </Col>
                  <Col xs="7">
                    <div className="numbers">
                      <p className="card-category">ROCAR</p>
                      <Card.Title as="h4">75%</Card.Title>
                    </div>
                  </Col>
                </Row>
              </Card.Body>
              <Card.Footer>
                <hr></hr>
                <div className="stats">
                  <i className="fas fa-redo mr-1"></i>
                  Redeem
                </div>
              </Card.Footer>
            </Card>
          </Col>
        </Row>
        <Row>
          <Col md="8">
          <Card className="strpied-tabled-with-hover">
              <Card.Header>
                <Card.Title as="h4">Available Underwriting Lots</Card.Title>
                <p className="card-category">
                 These are the pools in which you can invest
                </p>
              </Card.Header>
              <Card.Body className="table-full-width table-responsive px-0">
                <Table className="table-hover table-striped">
                  <thead>
                    <tr>
                      <th className="border-0">ID</th>
                      <th className="border-0">Lot</th>
                      <th className="border-0">Contract Count</th>
                      <th className="border-0">Distributor Risk(%)</th>
                      <th className="border-0">Inventory Covered</th>
                      <th className="border-0">Emissions (p/m) </th>
                      <th className="border-0">Min Term (months) </th> 
                    </tr>
                  </thead>
                  <tbody>
                    <tr>
                      <td>1</td>
                      <td>Alpha</td>
                      <td>20</td>
                      <td>20%</td>
                      <td>USDC $3,470,000</td>
                      <td>10%</td>
                      <td>9</td>
                    </tr>
                    <tr>
                      <td>2</td>
                      <td>Beta</td>
                      <td>10</td>
                      <td>15%</td>
                      <td>USDC $5,175,000</td>
                      <td>13%</td>
                      <td>18</td>
                    </tr>
                    <tr>
                      <td>3</td>
                      <td>Gamma</td>
                      <td>5</td>
                      <td>25%</td>
                      <td>USDC $17,670,000</td>
                      <td>14%</td>
                      <td>6</td>                    
                    </tr>
                    <tr>
                      <td>4</td>
                      <td>Lamda</td>
                      <td>25</td>
                      <td>10%</td>
                      <td>USDC $10,890,000</td>
                      <td>9%</td>
                      <td>12</td>
                    </tr>
                    <tr>
                      <td>5</td>
                      <td>Phi</td>
                      <td>300</td>
                      <td>5%</td>
                      <td>USDC $150,050,100</td>
                      <td>7%</td>
                      <td>24</td>
                    </tr>
                    <tr>
                      <td>6</td>
                      <td>Theta</td>
                      <td>50</td>
                      <td>15%</td>
                      <td>USDC $13,590,871</td>
                      <td>12%</td>
                      <td>18</td>
                    </tr>
                  </tbody>
                </Table>
              </Card.Body>
            </Card>
          </Col>
          <Col md="4">
          <Card>
              <Card.Header>
                <Card.Title as="h4">Join Lot</Card.Title>
              </Card.Header>
              <Card.Body>
                <Form>
                  <Row>
                    <Col className="pr-1" md="4">
                      <Form.Group>
                        <label>Lot </label>
                        <Form.Control
                          defaultValue="Ci"
                          disabled                      
                          type="text"
                        ></Form.Control>
                      </Form.Group>
                    </Col>
                    <Col className="px-1" md="4">
                      <Form.Group>
                        <label>Current Cap. (USDC) </label>
                        <Form.Control
                          defaultValue="4,056,356"                          
                          disabled
                          type="text"
                        ></Form.Control>
                      </Form.Group>
                    </Col>
                    <Col className="pl-1" md="4">
                      <Form.Group>
                        <label >
                          Max Capacity (USDC)
                        </label>
                        <Form.Control
                          defaultValue="10,789,890"
                          disabled
                          type="text"
                        ></Form.Control>
                      </Form.Group>
                    </Col>
                  </Row>
                  <Row>
                    <Col className="pr-1" md="4">
                      <Form.Group>
                        <label>Emissions (%)</label>
                        <Form.Control
                          defaultValue="12.5"
                          disabled                       
                          type="text"
                        ></Form.Control>
                      </Form.Group>
                    </Col>
                    <Col className="pl-1" md="4">
                      <Form.Group>
                        <label>Min Term (months)</label>
                        <Form.Control
                          defaultValue="12"
                          disabled
                          type="text"
                        ></Form.Control>
                      </Form.Group>
                    </Col>
                    <Col className="pl-1" md="4">
                      <Form.Group>
                        <label>Ave. Utlisation (%)</label>
                        <Form.Control
                          defaultValue="20%"
                          disabled
                          type="text"
                        ></Form.Control>
                      </Form.Group>
                    </Col>
                  </Row>
                  <Row>
                    <Col md="12">
                      <Form.Group>
                        <label>Investment (USDC)</label>
                        <Form.Control
                          defaultValue=""
                          placeholder="Amount to contribute to pool"
                          type="text"
                        ></Form.Control>
                      </Form.Group>
                    </Col>
                  </Row>

                  <Button
                    className="btn-fill pull-right"
                    type="submit"
                    variant="info"
                  >
                    Commit Funds
                  </Button>
                  <div className="clearfix"></div>
                </Form>
              </Card.Body>
            </Card>
          </Col>
        </Row>
        <Row>
        <Col md="12">
            <Card className="card-plain table-plain-bg">
              <Card.Header>
                <Card.Title as="h4">Your Lot Coupons</Card.Title>
                <p className="card-category">
                  Coupons with investment amounts
                </p>
              </Card.Header>
              <Card.Body className="table-full-width table-responsive px-0">
                <Form>
                <Table className="table-hover">
                  <thead>
                    <tr>
                      <th className="border-0">ID</th>
                      <th className="border-0">Lot</th>
                      <th className="border-0">Investment (USDC) </th>
                      <th className="border-0">Emission (%)</th>
                      <th className="border-0">Remaining Term (months)</th>
                      <th  className="border-0">Transfer</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr>
                      <td>1</td>
                      <td>Eta</td>
                      <td>$36,738</td>
                      <td>6</td>
                      <td>9</td>
                      <td>     
                        <Form.Group>
                        <Form.Control
                          defaultValue="unchecked"
                          type="checkbox"
                        ></Form.Control>
                      </Form.Group>
                      </td>
                    </tr>
                    <tr>
                      <td>2</td>
                      <td>Iota</td>
                      <td>$23,789</td>
                      <td>7</td>
                      <td>10</td>
                      <td>     
                        <Form.Group>
                        <Form.Control
                          defaultValue="unchecked"
                          type="checkbox"
                        ></Form.Control>
                      </Form.Group>
                      </td>
                    </tr>
                    <tr>
                      <td>3</td>
                      <td>Nu</td>
                      <td>$56,142</td>
                      <td>7</td>
                      <td>10</td>
                      <td>     
                        <Form.Group>
                        <Form.Control
                          defaultValue="unchecked"
                          type="checkbox"
                        ></Form.Control>
                      </Form.Group>
                      </td>
                    </tr>
                    <tr>
                      <td>4</td>
                      <td>Omicron</td>
                      <td>$38,735</td>
                      <td>7</td>
                      <td>10</td>
                       <td>     
                        <Form.Group>
                        <Form.Control
                          defaultValue="unchecked"
                          type="checkbox"
                        ></Form.Control>
                      </Form.Group>
                      </td>
                    </tr>
                    <tr>
                      <td>5</td>
                      <td>Kappa</td>
                      <td>$63,542</td>
                      <td>7</td>
                      <td>10</td>
                      <td>     
                        <Form.Group>
                        <Form.Control
                          defaultValue="unchecked"
                          type="checkbox"
                        ></Form.Control>
                      </Form.Group>
                      </td>
                    </tr>
                    <tr>
                      <td>6</td>
                      <td>Epsilong</td>
                      <td>$78,615</td>
                      <td>7</td>
                      <td>10</td>
                      <td>     
                        <Form.Group>
                        <Form.Control
                          defaultValue="unchecked"
                          type="checkbox"
                        ></Form.Control>
                      </Form.Group>
                      </td>
                    </tr>
                  </tbody>
                </Table>
                </Form> 
                <Button
                    className="btn-fill pull-right"
                    type="submit"
                    variant="info"
                  >
                   Transfer Coupons
                  </Button>
                  <div className="clearfix"></div>
              </Card.Body>
            </Card>
          </Col>
        </Row>
      </Container>
    </>
  );
}

export default Dashboard;
